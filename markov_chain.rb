#!/usr/bin/env ruby

class String
  def each_char
    if block_given?
      scan(/./m) do |x|
        yield x
      end
    else
      scan(/./m)
    end
  end
end

class MarkovChain
  def initialize
    @chars = Hash.new
  end

  def add_str(str)
    index = 0
    str.each_char do |char|
      add(char, str[index + 1]) if index <= str.size - 2
      index += 1
    end
  end

  def add(char, next_char)
    @chars[char] = Hash.new(0) if !@chars[char]
    @chars[char][next_char] += 1
  end

  def get(char)
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
end

original_word = ARGV[0]

words = []

target_length = original_word.length + 6

mc = MarkovChain.new
f = File.read('american-english')
f.each do |line|
  s = line.strip()
  mc.add_str(s)
end

100.times do
  word = original_word.dup
  char = word.slice(word.length - 1, 1)
  word.chop!

  while word.length < target_length
    word << char
    words.push(word.clone)
    char = mc.get(word.slice(word.length - 1, 1))
  end
end

words = words.sort { |a, b| a.length <=> b.length }.uniq
words.each do |word|
  puts word
end
