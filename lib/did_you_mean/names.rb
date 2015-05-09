require "delegate"

module DidYouMean
  class ColumnName < SimpleDelegator
    attr :type

    def initialize(name, type)
      super(name)
      @type = type
    end
  end
end
