require "did_you_mean/edit_distance"

module DidYouMean
  class WordCollection
    include Enumerable
    attr_reader :words

    def initialize(words)
      @words = words
    end

    def each(&block) words.each(&block); end

    def similar_to(target_word)
      target_word = target_word.to_s.downcase
      threshold   = target_word.length > 3 ? 0.834 : 0.77

      map {|word| [JaroNishijimaWinkler.distance(word.to_s.downcase, target_word), word] }
        .select {|distance, _| distance >= threshold }
        .sort
        .reverse
        .map(&:last)
        .select do |word|
          word = word.to_s.downcase

          threshold = if word.start_with?(target_word)
            (word.size > target_word.size ? word : target_word).size * 0.32
          else
            target_word.size * 0.3
          end.ceil

          Levenshtein.distance(word, target_word) <= threshold
        end
    end
  end
end
