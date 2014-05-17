module DidYouMean
  class SimilarNameFinder
    attr_reader :name, :_methods, :_local_variables, :original_message

    def self.build(exception)
      methods          = exception.frame_binding.eval("methods")
      local_variables  = exception.frame_binding.eval("local_variables")
      original_message = exception.original_message

      new(exception.name, methods, local_variables, original_message)
    end

    def initialize(name, methods, local_variables, original_message)
      @name, @_methods, @_local_variables, @original_message =
        name, methods, local_variables, original_message
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "   Did you mean?\n"

      unless similar_methods.empty?
        output << "     instance methods: ##{similar_methods.first}\n"
        output << similar_methods[1..-1].map{|word| "#{' ' * 23}##{word}\n" }.join
      end

      output << "\n" if !similar_methods.empty? && !similar_local_variables.empty?

      unless similar_local_variables.empty?
        output << "      local variables: #{similar_local_variables.map.first}\n"
        output << similar_local_variables[1..-1].map{|word| "#{' ' * 23}##{word}\n" }.join
      end

      output
    end

    def empty?
      !undefined_local_variable_or_method? || (similar_methods.empty? && similar_local_variables.empty?)
    end

    def similar_methods
      @similar_methods ||= DidYouMean::MethodMatcher.new(_methods, name).similar_methods
    end

    def similar_local_variables
      @similar_local_variables ||= DidYouMean::MethodMatcher.new(_local_variables, name).similar_methods
    end

    def undefined_local_variable_or_method?
      original_message.include?("undefined local variable or method")
    end
  end
end
