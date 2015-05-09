require "delegate"

module DidYouMean
  class AttributeFinder
    include BaseFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = (/unknown attribute(: | ')(\w+)/ =~ exception.original_message) && $2
    end

    def searches
      {attribute_name => columns.map(&:name) }
    end

    def suggestions
      super.map do |name|
        ColumnName.new(name, columns.detect{|c| c.name == name }.type)
      end
    end

    class ColumnName < SimpleDelegator
      attr :type

      def initialize(name, type)
        super(name)
        @type = type
      end

      def to_s
        "%{column}: %{type}" % {
          column: __getobj__,
          type:   type
        }
      end
    end

    private_constant :ColumnName
  end
end
