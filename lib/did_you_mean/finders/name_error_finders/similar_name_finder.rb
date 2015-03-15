module DidYouMean
  class SimilarNameFinder
    include BaseFinder
    attr_reader :name, :method_names, :lvar_names, :ivar_names, :cvar_names

    def initialize(exception)
      @name          = exception.name
      @lvar_names    = exception.frame_binding.eval("local_variables").map(&:to_s)
      @method_names  = exception.frame_binding.eval("methods + private_methods").map do |name|
        MethodName.new(name.to_s)
      end
      @cvar_names    = exception.frame_binding.eval("self.class.class_variables").map do |name|
        CvarName.new(name.to_s.tr(AT, EMPTY))
      end
      @ivar_names    = exception.frame_binding.eval("instance_variables").map do |name|
        IvarName.new(name.to_s.tr(AT, EMPTY))
      end
    end

    def searches
      {name => (lvar_names + method_names + ivar_names + cvar_names)}
    end
  end
end
