require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'markov_chain'
    s.summary = %Q{
      A simple Markov chain generator.
    }
    s.email = 'alexrabarts@gmail.com'
    s.homepage = 'http://github.com/alexrabarts/markov_chain'
    s.description = 'Markov chain generator'
    s.authors = ['Alex Rabarts']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test