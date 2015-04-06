module DidYouMean
  module Jaro
    module_function

    def distance(str1, str2)
      str1, str2 = str2, str1 if str1.length > str2.length
      length1, length2 = str1.length, str2.length

      m          = 0
      t          = 0
      window     = (length2 / 2).floor - 1
      prev_index = -1

      # Create an array of the codepoints for the str2 outside
      # of the loop to avoid duplicating it.
      str2_codepoints = str2.codepoints

      str1.each_codepoint.with_index do |char1, i|
        start = (i >= window) ? i - window : 0

        matched = false
        found   = false
        str2_codepoints[start, i + window + 1].each_with_index do |char2, j|
          if char1 == char2
            matched = true

            str2_index = start + j
            if !found && str2_index > prev_index
              prev_index = str2_index
              found = true
            end
          end
        end
        if matched
          m += 1
          t += 1 unless found
        end
      end

      m = m.to_f
      m == 0 ? 0 : (m / length1 + m / length2 + (m - t) / m) / 3
    end
  end

  module JaroWinkler
    WEIGHT    = 0.1
    THRESHOLD = 0.7

    module_function

    def distance(str1, str2)
      jaro_distance = Jaro.distance(str1, str2)

      if jaro_distance > THRESHOLD
        prefix_bonus = 0
        str1[0, 4].each_codepoint.with_index do |char1, i|
          char1 == str2[i].ord ? prefix_bonus += 1 : break
        end

        jaro_distance + (prefix_bonus * WEIGHT * (1 - jaro_distance))
      else
        jaro_distance
      end
    end
  end
end
