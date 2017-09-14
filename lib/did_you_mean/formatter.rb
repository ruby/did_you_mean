# frozen-string-literal: true

module DidYouMean
  class Formatter
    def initialize(corrections = [])
      @corrections = corrections
    end

    def to_s
      @corrections.empty? ? "" : "\nDid you mean?  #{@corrections.join("\n               ")}"
    end
  end
end
