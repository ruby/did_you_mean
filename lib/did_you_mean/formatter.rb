module DidYouMean
  class Formatter
    def initialize(corrections = [])
      @corrections = corrections
    end

    def to_s
      return "".freeze if @corrections.empty?

      output = "\n"
      output << "Did you mean?  #{format(@corrections.first)}"
      output << @corrections.drop(1).map{|word| "\n#{' '.freeze * 15}#{format(word)}" }.join
    end

    def format(name)
      name
    end
  end
end
