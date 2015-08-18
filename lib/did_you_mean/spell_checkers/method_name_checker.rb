module DidYouMean
  class MethodNameChecker
    include SpellCheckable
    attr_reader :method_name, :receiver

    REPLS = {
      "(irb)" => -> { Readline::HISTORY.to_a.last }
    }

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @binding     = exception.frame_binding
      @location    = exception.backtrace_locations.first
      @ivar_names  = VariableNameChecker.new(exception).ivar_names
    end

    def candidates
      {
        method_name        => method_names,
        receiver_name.to_s => @ivar_names
      }
    end

    def method_names
      method_names = receiver.methods + receiver.singleton_methods
      method_names += receiver.private_methods if receiver.equal?(@binding.receiver)
      method_names.delete(method_name)
      method_names.uniq!
      method_names
    end

    def receiver_name
      return unless @receiver.nil?

      abs_path = @location.absolute_path
      lineno   = @location.lineno

      /@(\w+)*\.#{@method_name}/ =~ line(abs_path, lineno).to_s && $1
    end

    private

    def line(abs_path, lineno)
      if REPLS[abs_path]
        REPLS[abs_path].call
      elsif File.exist?(abs_path)
        File.open(abs_path) do |file|
          file.detect { file.lineno == lineno }
        end
      end
    end
  end
end
