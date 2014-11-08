module DidYouMean
  module TestHelper
    def assert_suggestion(array, expected)
      assert (array.include?(expected) && array.one?), "Expected #{array.inspect} to only include #{expected.inspect}."
    end

    def assert_suggestions(array, *expected)
      expected.each {|s| assert_suggestion(array, s) }
    end
  end
end
