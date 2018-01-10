# frozen-string-literal: true

require "did_you_mean/levenshtein"
require "did_you_mean/jaro_winkler"

module DidYouMean
  class SpellChecker
    def initialize(dictionary: )
      @dictionary = dictionary
    end

    def correct(input)
      input        = normalize(input)
      input_length = input.length
      threshold    = input_length > 3 ? 0.834 : 0.77

      words = @dictionary.reject {|word| input == word.to_s }
      words.select! {|word| JaroWinkler.distance(normalize(word), input) >= threshold }
      words.sort_by! {|word| JaroWinkler.distance(word.to_s, input) }
      words.reverse!

      # Correct mistypes
      threshold   = (input_length * 0.25).ceil
      corrections = words.select {|c| Levenshtein.distance(normalize(c), input) <= threshold }

      # Correct misspells
      if corrections.empty?
        corrections = words.select do |word|
          word   = normalize(word)
          length = input_length < word.length ? input_length : word.length

          Levenshtein.distance(word, input) < length
        end.first(1)
      end

      corrections
    end

    private

    def normalize(str_or_symbol) #:nodoc:
      str = if str_or_symbol.is_a?(String)
              str_or_symbol.dup
            else
              str_or_symbol.to_s
            end

      str.downcase!
      str.tr!("@", "")
      str
    end
  end
end
