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
      target_word = target_word.to_s.downcase
      threshold   = target_word.length > 3 ? 0.831 : 0.77

      map {|word| [JaroWinkler.distance(word.to_s.downcase, target_word), word] }
        .select {|distance, _| distance >= threshold }
        .sort
        .reverse
        .map(&:last)
    end
  end
end
