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

      str1.each_char.with_index(1) do |char1, i|
        str2.each_char.with_index do |char2, j|
          insertion_cost    = d[j+1] + 1
          deletion_cost     = i + 1
          substitution_cost = d[j] + ((char1 == char2) ? 0 : 1)

          x = [insertion_cost, deletion_cost, substitution_cost].min
          d[j] = i
          i = x
        end
        d[m] = x
      end

      x
    end
    module_function :distance
  end
end
