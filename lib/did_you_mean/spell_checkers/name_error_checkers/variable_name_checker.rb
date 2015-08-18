module DidYouMean
  class VariableNameChecker
    include SpellCheckable
    attr_reader :name, :method_names, :lvar_names, :ivar_names, :cvar_names

    def initialize(exception)
      @name       = exception.name.to_s.tr(AT, EMPTY)
      @lvar_names = exception.frame_binding.local_variables
      receiver    = exception.frame_binding.receiver

      @method_names = receiver.methods + receiver.private_methods
      @cvar_names   = receiver.class.class_variables
      @ivar_names   = receiver.instance_variables
    end

    def searches
      { name => (lvar_names + method_names + ivar_names + cvar_names) }
    end
  end
end
