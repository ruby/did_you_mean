require_relative 'test_helper'

class NullFinderTest < Minitest::Test
  class FirstNameError < NameError; end

  def setup
    @error = assert_raises(FirstNameError) do
      raise FirstNameError, "Other name error"
    end
  end

  def test_similar_words
    assert_empty @error.method_finder.similar_words
  end

  def test_did_you_mean?
    assert_nil @error.did_you_mean?
  end

  def test_message
    assert !@error.message.include?("Did you mean?")
  end
end
