require "delegate"
require "did_you_mean/levenshtein"
require "did_you_mean/jaro_winkler"

module DidYouMean
  class WordCollection
    include Enumerable
    attr_reader :words

    def initialize(words)
      @words = words
    end

    def each(&block) words.each(&block); end

    def similar_to(target_word)
      target_word = MemoizingString.new(target_word.to_s.downcase)

      map {|word| Pair.new(word, target_word) }
        .select(&:close_enough?)
        .sort {|a,b| a.levenshtein <=> b.levenshtein }
        .map(&:word)
    end

    class MemoizingString < SimpleDelegator #:nodoc:
      def length;     @length     ||= super; end
      def codepoints; @codepoints ||= super; end
    end

    class Pair #:nodoc:
      attr_reader :word, :input

      def initialize(word, input)
        @word  = word
        @input = input
      end

      def jaro_winkler
        @jaro_winkler ||= JaroWinkler.distance(word.to_s.downcase, input)
      end

      def levenshtein
        @levenshtein ||= Levenshtein.distance(word.to_s.downcase, input)
      end

      def close_enough?
        jaro_winkler >= (input.length > 3 ? 0.834 : 0.77) && (levenshtein <= 1 || jaro_winkler >= threshold)
      end

      private

      def threshold
        num = (- 0.6 / levenshtein) + 1
        num + ((1 - num) * ((levenshtein.to_f / input.length) ** Math::E))
      end
    end

    private_constant :MemoizingString, :Pair
  end
end
