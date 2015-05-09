module DidYouMean
  module Formatters
    class Plain
      def initialize(suggestions = [])
        @suggestions = suggestions
      end

      def to_s
        output = "\n\n"
        output << "    Did you mean? #{format(@suggestions.first)}\n"
        output << @suggestions.drop(1).map{|word| "#{' ' * 18}#{format(word)}\n" }.join
        output << " " # for rspec
      end

      def format(name)
        case name
        when ColumnName
          "%{column}: %{type}" % {
            column: name,
            type:   name.type
          }
        else
          name
        end
      end
    end
  end
end
