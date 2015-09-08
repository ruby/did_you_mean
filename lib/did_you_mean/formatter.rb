module DidYouMean
  class Formatter
    def initialize(corrections = [])
      @corrections = corrections
    end

    def to_s
      return "".freeze if @corrections.empty?

      output = "\nDid you mean?  "
      output << @corrections.join("\n" << ' '.freeze * 15)
    end
  end
end
