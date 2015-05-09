require "did_you_mean/word_collection"

module DidYouMean
  module BaseFinder
    AT     = "@".freeze
    EMPTY  = "".freeze
    FILTER = AT

    def suggestions
      @suggestions ||= searches.flat_map {|_, __| WordCollection.new(__).similar_to(_, FILTER) }
    end

    def searches
      raise NotImplementedError
    end
  end

  class NullFinder
    def initialize(*);  end
    def suggestions; [] end
  end
end

require 'did_you_mean/finders/name_error_finders'
require 'did_you_mean/finders/method_finder'
