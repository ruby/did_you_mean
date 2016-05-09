require 'test_helper'

class VerboseFormatterTest < Minitest::Test
  def setup
    @error = assert_raises(NameError){ self.inspectt }
  end

  def test_message
    assert_equal <<~MESSAGE.chomp, @error.message
      undefined method `inspectt' for #{method(:to_s).super_method.call}

          Did you mean? inspect
       
    MESSAGE
  end
end
