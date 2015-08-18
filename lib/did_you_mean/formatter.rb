module DidYouMean
  class Formatter
    def initialize(corrections = [])
      @corrections = corrections
    end

    def to_s
      return "".freeze if @corrections.empty?

      output = "\n\n"
      output << "    Did you mean? #{format(@corrections.first)}\n"
      output << @corrections.drop(1).map{|word| "#{' '.freeze * 18}#{format(word)}\n" }.join
      output << " ".freeze
    end

    def format(name)
      name
    end
  end
end
