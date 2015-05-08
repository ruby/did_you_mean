require "delegate"
require "did_you_mean/levenshtein"
require "did_you_mean/jaro_winkler"

module DidYouMean
  class WordCollection
    EMPTY = "".freeze

    include Enumerable
    attr_reader :words

    def initialize(words)
      @words = words
    end

    def each(&block) words.each(&block); end

    def similar_to(input, filter = EMPTY)
      input = MemoizingString.new(input.to_s.downcase)

      select {|word| close_enough?(normalize(word, filter), input) }
        .sort_by! {|word| JaroWinkler.distance(word.to_s, input) }
        .reverse!
    end

    private

    def normalize(str_or_symbol, filter = EMPTY) #:nodoc:
      str = if str_or_symbol.is_a?(String)
              str_or_symbol.downcase
            else
              str = str_or_symbol.to_s
              str.downcase!
              str
            end

      str.tr!(filter, EMPTY)
      str
    end

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

    class MemoizingString < SimpleDelegator #:nodoc:
      def length;     @length     ||= super; end
      def codepoints; @codepoints ||= super; end
    end

    private_constant :MemoizingString
  end
end
