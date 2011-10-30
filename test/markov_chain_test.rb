require File.dirname(__FILE__) + '/test_helper'

class MarkovChainTest < Test::Unit::TestCase
  should 'load default dictionary' do
    MarkovChain.load_dictionary!
    assert MarkovChain.dictionary_loaded?
    assert_equal 'american_english', File.basename(MarkovChain.dictionary)
  end

  should 'generate 100 words by default' do
    assert_equal 100, MarkovChain.generate('foo').length
  end
end
