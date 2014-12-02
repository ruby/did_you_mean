module DidYouMean
  module Formatters
    class Plain
      def initialize(suggestions)
        @suggestions = suggestions
      end

      def to_s
        output = "\n\n"
        output << "    Did you mean? #{format(@suggestions.first)}\n"
        output << @suggestions.drop(1).map{|word| "#{' ' * 18}#{format(word)}\n" }.join
        output << " " # for rspec
      end

      def format(name)
        case name.type
        when :instance_variable
          "@#{name}"
        when :method
          name.with_prefix
        when :attribute
          "%{column}: %{type}" % {
            column: name,
            type:   name.options[:column_type]
          }
        else
          name
        end
      end
    end

    class Pry
      def initialize(suggestions)
        @suggestions = suggestions
      end

      def to_s
        output = "\n\n"
        output << "    " + red('Did you mean?') + " #{format(@suggestions.first)}\n"
        output << @suggestions.drop(1).map{|word| "#{' ' * 18}#{format(word)}\n" }.join
        output << " "
      end

      private

      def format(name)
        case name.type
        when :instance_variable
          yellow("@#{name}")
        when :method
          name.with_prefix
        when :constant
          name.split("::").map do |constant|
            blue(underline(constant))
          end.join("::")
        when :attribute
          "%{column}: %{type}" % {
            column: magenda(name),
            type:   name.options[:column_type]
          }
        else
          name
        end
      end

      def       red(str); "\e[31m#{str}\e[0m" end
      def    yellow(str); "\e[33m#{str}\e[0m" end
      def      blue(str); "\e[34m#{str}\e[0m" end
      def   magenda(str); "\e[35m#{str}\e[0m" end
      def underline(str); "\e[4m#{str}\e[0m"  end
    end
  end
end
