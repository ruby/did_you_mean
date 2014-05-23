module DidYouMean
  class SimilarMethodFinder
    attr_reader :name, :receiver

    def initialize(exception)
      @name, @receiver = exception.name, exception.args.first
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "   Did you mean? #{separator}#{similar_methods.first}\n"
      output << similar_methods[1..-1].map{|word| "#{' ' * 17}#{separator}#{word}\n" }.join
      output
    end

    def empty?
      similar_methods.empty?
    end

    def similar_methods
      @similar_methods ||= MethodMatcher.new(receiver.methods + receiver.singleton_methods, name).similar_methods
    end

    private

    def receiver_name
      class_method? ? receiver.name : receiver.class.name
    end

    def separator
      class_method? ? "." : "#"
    end

    def class_method?
      receiver.is_a? Class
    end
  end

  strategies["NoMethodError"] = SimilarMethodFinder
end
