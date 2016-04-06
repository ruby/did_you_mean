module DidYouMean
  class MethodNameChecker
    include SpellCheckable
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @private_call = exception.private_call?
    end

    def candidates
      { method_name => method_names }
    end

    def method_names
      method_names = receiver.methods + receiver.singleton_methods
      method_names += receiver.private_methods if @private_call
      method_names.uniq!
      method_names
    end
  end
end
