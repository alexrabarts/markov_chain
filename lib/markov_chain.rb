require 'singleton'

class MarkovChain
  include Singleton

  class << self
    def instance
      @__instance__ ||= new
    end

    def grow_string seed, options = {}
      raise ArgumentError, 'Seed must be at least two characters' unless seed.length > 1

      max_word_length = seed.length + 8

      defaults = {
        :max_size => 100,
        :max_word_length => max_word_length,
        :max_retries => 1000
      }

      options = defaults.merge options

      load_dictionary! unless dictionary_loaded?

      words = [seed]
      old_words = []
      retries = 0

      mc = MarkovChain.instance

      while words.length < options[:max_size] && retries < options[:max_retries] do
        old_words = words.dup
        word = seed.dup
        old_word = ''

        while word.length < options[:max_word_length] && word != old_word
          old_word = word.dup
          word << mc.get(word.slice(word.length - 1, 1))
          words.push word.dup
        end

        words = words.map { |w| w.gsub(/[^a-z]/, '') }.uniq

        retries += 1 if words == old_words
      end

      words = words[0..(options[:max_size] - 1)]

      words.sort { |a, b| a.length <=> b.length }
    end

    def load_dictionary! file = :american_english
      if file.class == Symbol
        file = File.join File.dirname(__FILE__), 'dictionaries', file.to_s
      end

      dictionary = File.read file

      if dictionary
        dictionary.each do |line|
          s = line.strip
          instance.add_str s
        end

        @dictionary_loaded = true
        @dictionary = File.expand_path file
      end
    end

    def dictionary_loaded?
      !!@dictionary_loaded
    end

    def dictionary
      @dictionary
    end
  end

  def initialize
    @chars = Hash.new
  end

  def add_str str
    index = 0
    each_char(str) do |char|
      add(char, str[index + 1]) if index <= str.size - 2
      index += 1
    end
  end

  def add char, next_char
    @chars[char] = Hash.new(0) if !@chars[char]
    @chars[char][next_char] += 1
  end

  def get char
    return '' if !@chars[char]

    followers = @chars[char]
    sum = followers.inject(0) { |sum,kv| sum += kv[1] }
    random = rand(sum) + 1
    partial_sum = 0

    next_char = followers.find do |char, count|
      partial_sum += count
      partial_sum >= random
    end.first

    next_char
  end

  private

  def each_char str
    if block_given?
      str.scan(/./m) do |x|
        yield x
      end
    else
      str.scan /./m
    end
  end
end
