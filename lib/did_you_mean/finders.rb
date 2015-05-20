require "did_you_mean/levenshtein"
require "did_you_mean/jaro_winkler"

module DidYouMean
  module BaseFinder
    AT    = "@".freeze
    EMPTY = "".freeze

    def suggestions
      @suggestions ||= searches.flat_map do |input, candidates|
        input = MemoizingString.new(input.to_s.downcase)

        candidates.select {|candidate| close_enough?(normalize(candidate), input) }
          .sort_by! {|candidate| JaroWinkler.distance(candidate.to_s, input) }
          .reverse!
      end
    end

    def searches
      raise NotImplementedError
    end

    private

    def close_enough?(word, input) #:nodoc:
      jaro_winkler = JaroWinkler.distance(word, input)
      threshold    = input.length > 3 ? 0.834 : 0.77

      if jaro_winkler >= threshold
        levenshtein = Levenshtein.distance(word, input)
        bound       = (- 0.6 / levenshtein) + 1
        bound       = bound + ((1 - bound) * ((levenshtein.to_f / input.length) ** Math::E))

        levenshtein <= 1 || jaro_winkler >= bound
      end
    end

    def normalize(str_or_symbol) #:nodoc:
      str = if str_or_symbol.is_a?(String)
              str_or_symbol.downcase
            else
              str = str_or_symbol.to_s
              str.downcase!
              str
            end

      str.tr!(AT, EMPTY)
      str
    end

    class MemoizingString < SimpleDelegator #:nodoc:
      def length;     @length     ||= super; end
      def codepoints; @codepoints ||= super; end
    end

    private_constant :MemoizingString
  end

  class NullFinder
    def initialize(*);  end
    def suggestions; [] end
  end
end

require 'did_you_mean/finders/name_error_finders'
require 'did_you_mean/finders/method_finder'
