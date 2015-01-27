require "did_you_mean/names"
require "did_you_mean/word_collection"

module DidYouMean
  module BaseFinder
    AT    = "@".freeze
    EMPTY = "".freeze

    def did_you_mean?
      return if DidYouMean.disabled? || suggestions.empty?

      DidYouMean.formatter.new(suggestions).to_s
    end

    def suggestions
      @suggestions ||= WordCollection.new(words).similar_to(target_word)
    end
  end

  class NullFinder
    def initialize(*); end
    def did_you_mean?; end
  end
end

require 'did_you_mean/finders/name_error_finders'
require 'did_you_mean/finders/similar_attribute_finder'
require 'did_you_mean/finders/similar_method_finder'
