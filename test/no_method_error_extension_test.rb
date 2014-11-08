require_relative 'test_helper'

class NoMethodErrorExtensionTest < Minitest::Test
  def setup
    @receiver = "receiver"
    @error = assert_raises(NoMethodError) do
      @receiver.doesnt_exist
    end
  end

  def test_receiver
    assert_same @receiver, @error.args.first
  end

  def test_extension_doesnt_break_ruby
    assert_nothing_raised do
      File.open('tmp/foo.txt', 'w'){|f| Array(Mail.new) }
    end
  end
end
