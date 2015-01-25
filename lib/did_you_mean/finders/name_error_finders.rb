module DidYouMean
  module NameErrorFinders
    def self.included(*)
      raise "Do not include this module since it overrides Class.new method."
    end

    def self.new(exception)
      case exception.original_message
      when /uninitialized constant/
        SimilarClassFinder
      when /undefined local variable or method/, /undefined method/
        SimilarNameFinder
      else
        NullFinder
      end.new(exception)
    end
  end
end

require 'did_you_mean/finders/name_error_finders/similar_name_finder'
require 'did_you_mean/finders/name_error_finders/similar_class_finder'
