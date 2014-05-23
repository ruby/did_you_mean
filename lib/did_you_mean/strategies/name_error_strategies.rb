module DidYouMean
  module NameErrorStrategies
    def self.included(*)
      raise "Do not include this module since it overrides Class.new method."
    end

    def self.new(exception)
      klass = if /uninitialized constant/ =~ exception.original_message
        SimilarClassFinder
      else
        SimilarNameFinder
      end

      klass.new(exception)
    end
  end

  strategies["NameError"] = NameErrorStrategies
end

require 'did_you_mean/strategies/name_error_strategies/similar_name_finder'
require 'did_you_mean/strategies/name_error_strategies/similar_class_finder'
