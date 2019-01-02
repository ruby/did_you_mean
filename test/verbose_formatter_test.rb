require 'test_helper'

class VerboseFormatterTest < Minitest::Test
  def setup
    require 'did_you_mean/verbose'

    @error = assert_raises(NameError){ 1.zeor? }
  end

  def teardown
    DidYouMean.formatter = DidYouMean::PlainFormatter.new
  end

  def test_message
    assert_equal <<~MESSAGE.chomp, @error.message
      undefined method `zeor?' for 1:Integer

          Did you mean? zero?
       
    MESSAGE
  end
end
