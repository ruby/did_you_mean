module DidYouMean
  class Formatter
    def initialize(suggestions = [])
      @suggestions = suggestions
    end

    def to_s
      return "".freeze if @suggestions.empty?

      output = "\n\n"
      output << "    Did you mean? #{format(@suggestions.first)}\n"
      output << @suggestions.drop(1).map{|word| "#{' '.freeze * 18}#{format(word)}\n" }.join
      output << " ".freeze
    end

    def format(name)
      name
    end
  end
end
