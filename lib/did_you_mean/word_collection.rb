require 'did_you_mean/levenshtein'

module DidYouMean
  class WordCollection
    include Enumerable
    attr_reader :words

    def initialize(words)
      @words = words
    end

    def each(&block) words.each(&block); end

    def similar_to(target_word)
      select do |word|
        Levenshtein.distance(word.to_s, target_word.to_s) <= threshold(target_word)
      end
    end

    private

    def threshold(word)
      (word.size * 0.3).ceil
    end
  end
end
