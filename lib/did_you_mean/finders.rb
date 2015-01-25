require "delegate"
require "did_you_mean/word_collection"

module DidYouMean
  module BaseFinder
    AT    = "@".freeze
    POUND = "#".freeze
    DOT   = ".".freeze
    EMPTY = "".freeze

    def did_you_mean?
      return if DidYouMean.disabled? || suggestions.empty?

      DidYouMean.formatter.new(suggestions).to_s
    end

    def suggestions
      @suggestions ||= WordCollection.new(words).similar_to(target_word)
    end

    class StringDelegator < ::Delegator
      attr :type, :options

      def initialize(name, type, options = {})
        super(name)
        @name, @type, @options = name, type, options
      end

      def __getobj__
        @name
      end

      def with_prefix
        self.class.new("#{options[:prefix]}#{@name}", @type)
      end

      # StringDelegator Does not allow to replace the object.
      def __setobj__(*); end
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
