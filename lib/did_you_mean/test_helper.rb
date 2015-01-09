module DidYouMean
  module TestHelper
    def assert_suggestion(array, expected)
      assert_equal Array(expected), array, "Expected #{array.inspect} to only include #{expected.inspect}"
    end
  end
end
