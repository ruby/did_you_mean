module DidYouMean
  module TestHelper
    def assert_suggestion(array, expected)
      assert_equal [expected], array, "Expected #{array.inspect} to only include #{expected.inspect}"
    end

    def assert_nothing_raised
      yield
    end
  end
end
