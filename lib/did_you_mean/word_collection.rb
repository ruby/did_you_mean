require "jaro_winkler"

module DidYouMean
  class WordCollection
    include Enumerable
    attr_reader :words

    def initialize(words)
      @words = words
    end

    def each(&block) words.each(&block); end

    THRESHOLD = 0.831

    def similar_to(target_word)
      target_word = target_word.to_s.downcase

      map {|word| [JaroWinkler.distance(word.to_s.downcase, target_word), word] }
        .select {|distance, _| distance >= THRESHOLD }
        .sort
        .reverse
        .map(&:last)
    end
  end
end
