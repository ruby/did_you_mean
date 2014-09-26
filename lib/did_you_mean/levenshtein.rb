module DidYouMean
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
          x = [
            d[j+1] + 1, # insertion
            e + 1,      # deletion
            d[j] + cost # substitution
          ].min
          d[j] = e
          e = x
        end
        d[m] = x
      end

      x
    end
    module_function :distance
  end
end
