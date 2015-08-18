module DidYouMean
  module Correctable
    attr_reader :frame_binding

    IGNORED_CALLERS = [
      /( |`)missing_name'/,
      /( |`)safe_constantize'/
    ].freeze
    private_constant :IGNORED_CALLERS

    def original_message
      method(:to_s).super_method.call
    end

    def to_s
      msg = super.dup
      bt  = caller(1, 6)

      msg << Formatter.new(suggestions).to_s if IGNORED_CALLERS.all? {|ignored| bt.grep(ignored).empty? }
      msg
    rescue
      super
    end

    def suggestions
      finder.suggestions
    end

    def finder
      @finder ||= DidYouMean.finders[self.class.to_s].new(self)
    end
  end
end

NameError.include(DidYouMean::Correctable)
