module DidYouMean
  class SimilarAttributeFinder
    attr_reader :columns, :unknown_attribute_name

    def self.build(exception)
      columns        = exception.frame_binding.eval("self.class").columns
      attribute_name = exception.original_message.gsub("unknown attribute: ", "")

      new(attribute_name, columns)
    end

    def initialize(unknown_attribute_name, columns)
      @unknown_attribute_name, @columns = unknown_attribute_name, columns
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "    Did you mean? #{similar_columns.first}\n"
      output << similar_columns[1..-1].map{|word| "#{' ' * 18}#{word}\n" }.join
      output
    end

    def empty?
      similar_columns.empty?
    end

    def similar_columns
      @similar_columns ||= MethodMatcher.new(column_names, unknown_attribute_name).similar_methods
    end

    private

    def column_names
      columns.map(&:name)
    end
  end

  strategies["ActiveRecord::UnknownAttributeError"] = SimilarAttributeFinder
end
