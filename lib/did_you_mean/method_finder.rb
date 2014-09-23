module DidYouMean
  class MethodMatcher
    attr_reader :method_collection, :target_method

    def initialize(method_collection, target_method)
      @method_collection = method_collection.uniq
      @target_method     = target_method.to_s
    end

    def similar_methods
      @similar_methods ||= method_collection.select do |method|
        Levenshtein.distance(method.to_s, target_method) <= threshold
      end
    end

    private

    def threshold
      (target_method.size * 0.3).ceil
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
