module DidYouMean
  class MethodNameChecker
    include SpellCheckable
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
    end

    def candidates
      { method_name => method_names }
    end

    def method_names
      method_names = receiver.methods + receiver.singleton_methods + receiver.private_methods
      method_names.delete(method_name)
      method_names.uniq!
      method_names
    end

    module IvarNameCorrectable
      REPLS = {
        "(irb)" => -> { Readline::HISTORY.to_a.last }
      }

      def initialize(exception)
        super

        @location   = exception.backtrace_locations.first
        @ivar_names = exception.frame_binding.receiver.instance_variables
      end

      def candidates
        super.merge(receiver_name.to_s => @ivar_names)
      end

      private

      def receiver_name
        return unless receiver.nil?

        abs_path = @location.absolute_path
        lineno   = @location.lineno

        /@(\w+)*\.#{method_name}/ =~ line(abs_path, lineno).to_s && $1
      end

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
end
