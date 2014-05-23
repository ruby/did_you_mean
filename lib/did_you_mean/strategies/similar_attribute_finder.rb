module DidYouMean
  class SimilarAttributeFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = exception.original_message.gsub("unknown attribute: ", "")
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "    Did you mean? #{format(similar_columns.first)}\n"
      output << similar_columns[1..-1].map{|word| "#{' ' * 18}#{format(word)}\n" }.join
      output
    end

    def empty?
      similar_columns.empty?
    end

    def similar_columns
      @similar_columns ||= MethodMatcher.new(columns.map(&:name), attribute_name).similar_methods
    end

    private

    def format(name)
      "%s: %s" % [name, columns.detect{|c| c.name == name }.type]
    end
  end

  strategies["ActiveRecord::UnknownAttributeError"] = SimilarAttributeFinder
end
