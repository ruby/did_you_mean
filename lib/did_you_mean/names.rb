require "delegate"

module DidYouMean
  class Name       < SimpleDelegator; end

  class ClassName  < Name
    attr :namespace

    def initialize(name, namespace = '')
      super(name)
      @namespace = namespace
    end

    def full_name
      self.class.new("#{namespace}#{__getobj__}")
    end
  end

  class ColumnName < Name
    attr :type

    def initialize(name, type)
      super(name)
      @type = type
    end
  end
end
