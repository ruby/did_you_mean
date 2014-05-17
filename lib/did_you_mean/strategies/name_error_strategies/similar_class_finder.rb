module DidYouMean
  class SimilarClassFinder
    attr_reader :name, :original_message

    def self.build(exception)
      new(exception.name, exception.original_message)
    end

    def initialize(name, original_message)
      @name, @original_message = name, original_message
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "   Did you mean? #{similar_classes.first}\n"
      output << similar_classes[1..-1].map{|word| "#{' ' * 17}#{word}\n" }.join
      output
    end

    def empty?
      name.nil? || name.empty? || similar_classes.empty?
    end

    def similar_classes
      @similar_classes ||= scopes.map do |scope|
        DidYouMean::MethodMatcher.new(scope.constants, name).similar_methods.map do |constant_name|
          if scope === Object
            constant_name.to_s
          else
            "#{scope}::#{constant_name}"
          end
        end
      end.flatten
    end

    private

    def scope_base
      @scope_base ||= (/(([A-Z]\w*::)*)([A-Z]\w*)$/ =~ original_message ? $1 : "").split("::")
    end

    def scopes
      @scopes ||= scope_base.size.times.map do |count|
        eval(scope_base[0..(- count)].join("::"))
      end.reverse << Object
    end
  end
end
