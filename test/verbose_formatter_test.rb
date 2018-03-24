require 'test_helper'

class VerboseFormatterTest < Minitest::Test
  def setup
    @error = assert_raises(NoMethodError){ self.inspectt }
  end

  def test_message
    assert_equal <<~MESSAGE.chomp, @error.message
      undefined method `inspectt' for #{to_s}

          Did you mean? inspect
       
    MESSAGE
  end
end
