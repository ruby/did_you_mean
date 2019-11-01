require 'test/unit'
require 'did_you_mean'

puts "DidYouMean version: #{DidYouMean::VERSION}"

module DidYouMean::TestHelper
  def assert_correction(expected, array)
    assert_equal Array(expected), array, "Expected #{array.inspect} to only include #{expected.inspect}"
  end
end

Test::Unit::TestCase.include(DidYouMean::TestHelper)
