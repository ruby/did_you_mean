require 'test/unit'

roots = [
  File.expand_path('../lib/did_you_mean', __dir__), # source
  File.expand_path('../../lib/did_you_mean', __dir__) # ruby core
]
  
require_relative roots.detect { |file| File.file?("#{file}.rb") }

puts "DidYouMean version: #{DidYouMean::VERSION}"

module DidYouMean::TestHelper
  def assert_correction(expected, array)
    assert_equal Array(expected), array, "Expected #{array.inspect} to only include #{expected.inspect}"
  end
end

Test::Unit::TestCase.include(DidYouMean::TestHelper)
