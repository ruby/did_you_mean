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

  module Levenshtein
    # This code is based directly on the Text gem implementation
    # Returns a value representing the "cost" of transforming str1 into str2
    def distance(str1, str2)
      n = str1.length
      m = str2.length
      return m if n.zero?
      return n if m.zero?

      d = (0..m).to_a
      x = nil

      str1.each_char.each_with_index do |char1, i|
        e = i + 1
        str2.each_char.each_with_index do |char2, j|
          cost = (char1 == char2) ? 0 : 1
          x = min3(
            d[j+1] + 1, # insertion
            e + 1,      # deletion
            d[j] + cost # substitution
          )
          d[j] = e
          e = x
        end
        d[m] = x
      end

      x
    end
    module_function :distance

    private

    def min3(a, b, c) # :nodoc:
      if a < b && a < c
        a
      elsif b < a && b < c
        b
      else
        c
      end
    end
    module_function :min3
  end
end
