module DidYouMean
  module Jaro
    module_function

    def distance(str1, str2)
      str1, str2 = str2, str1 if str1.length > str2.length
      length1, length2 = str1.length, str2.length

      m          = 0.0
      t          = 0.0
      range      = (length2 / 2).floor - 1
      flags1     = []
      flags2     = []

      # Avoid duplicating enumerable objects
      str1_codepoints = str1.codepoints
      str2_codepoints = str2.codepoints

      # On Ruby 1.9.3, #codepoints returns an Enumerator, not an array
      str2_codepoints = str2_codepoints.to_a if str2_codepoints.is_a?(Enumerator)

      str1_codepoints.each_with_index do |char1, i|
        start = (i >= range) ? i - range : 0

        str2_codepoints[start, i + range + 1].each_with_index do |char2, j|
          if !flags2[j + start] && char1 == char2
            flags2[j + start] = true
            flags1[i]         = true
            m += 1
            break
           end
         end
      end

      k = 0
      str1_codepoints.each_with_index do |char1, i|
        if flags1[i]
          index = k
          k = k.upto(length2) do |j|
            index = j
            break(j + 1) if flags2[j]
          end
          t += 1 if char1 != str2_codepoints[index]
         end
       end
      t = (t / 2).floor

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
        codepoints2  = str2.codepoints.to_a
        prefix_bonus = 0

        i = 0
        str1[0, 4].each_codepoint do |char1|
          char1 == codepoints2[i] ? prefix_bonus += 1 : break
          i += 1
        end

        jaro_distance + (prefix_bonus * WEIGHT * (1 - jaro_distance))
      else
        jaro_distance
      end
    end
  end
end
