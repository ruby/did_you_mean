module DidYouMean
  class NullChecker
    def initialize(*);  end
    def suggestions; [] end
    alias :corrections :suggestions
  end
end
