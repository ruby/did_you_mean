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
      target_word = target_word.to_s
      threshold   = threshold(target_word)
      map { |word| [Levenshtein.distance(word.to_s, target_word), word] }
        .select { |distance, _| distance <= threshold }
        .sort { |a, b| a[0] <=> b[0] }
        .map { |_, word| word }
    end

    private

    def threshold(word)
      (word.size * 0.3).ceil
    end
  end
end
