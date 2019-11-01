require 'helper'

class VerboseFormatterTest < Test::Unit::TestCase
  def setup
    require 'did_you_mean/verbose'
  end

  def teardown
    DidYouMean.formatter = DidYouMean::PlainFormatter.new
  end

  def test_message
    @error = assert_raises(NoMethodError){ 1.zeor? }

    assert_equal <<~MESSAGE.chomp, @error.message
      undefined method `zeor?' for 1:Integer

          Did you mean? zero?
       
    MESSAGE
  end
end
