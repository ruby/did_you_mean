NAME_ERROR = (___ rescue $!).class

require 'minitest/autorun'
require 'minitest/unit'
require 'did_you_mean'

begin
  MiniTest::Test
rescue NameError
  MiniTest::Test = MiniTest::Unit::TestCase
end

module DidYouMean::TestHelper
  def assert_suggestion(expected, array)
    assert_equal [expected], array, "Expected #{array.inspect} to only include #{expected.inspect}"
  end
end

MiniTest::Test.include(DidYouMean::TestHelper)
