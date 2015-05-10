case RUBY_ENGINE
when 'ruby'
  require 'did_you_mean/method_missing'

when 'jruby'
  NoMethodError.class_eval do
    if JRUBY_VERSION >= '9.0.0.0'
      def to_s
        receiver unless defined?(@receiver)
        super
      end

      def receiver
        @receiver ||= begin
          field = JRuby.reference(__message__).java_class.getDeclaredField("object")
          field.setAccessible(true)
          field.get(__message__)
        rescue
          nil
        end
      end

      private

      def __message__
        JRuby.reference(self).getMessage
      end
    else
      require 'did_you_mean/receiver_capturer'
      org.yukinishijima.ReceiverCapturer.setup(JRuby.runtime)
      attr_reader :receiver
    end
  end
end
