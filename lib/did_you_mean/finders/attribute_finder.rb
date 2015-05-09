module DidYouMean
  class AttributeFinder
    include BaseFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = (/unknown attribute(: | ')(\w+)/ =~ exception.original_message) && $2
    end

    def searches
      {attribute_name => columns.map{|c| ColumnName.new(c.name, c.type)} }
    end
  end
end
