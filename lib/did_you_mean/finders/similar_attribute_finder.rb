module DidYouMean
  class SimilarAttributeFinder
    include BaseFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = (/unknown attribute(: | ')(\w+)/ =~ exception.original_message) && $2
    end

    def words
      columns.map {|c| ColumnName.new(c.name, c.type) }
    end

    alias target_word attribute_name
  end
end
