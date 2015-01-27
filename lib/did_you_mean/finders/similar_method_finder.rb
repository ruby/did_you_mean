module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @location    = exception.backtrace.first
      @ivar_names  = SimilarNameFinder.new(exception).ivar_names
    end

    def suggestions
      super + WordCollection.new(@ivar_names).similar_to(receiver_name.to_s)
    end

    def words
      method_names = receiver.methods + receiver.singleton_methods
      method_names.delete(method_name)
      method_names.uniq.map {|name| MethodName.new(name.to_s) }
    end

    alias target_word method_name

    def receiver_name
      return unless @receiver.nil?

      abs_path, lineno, label =
        /(.*):(.*):in `(.*)'/ =~ @location && [$1, $2.to_i, $3]

      line =
        case label
        when "irb_binding"
          Readline::HISTORY.to_a.last
        when "__pry__"
          Pry.history.to_a.last
        else
          File.open(abs_path) do |file|
            file.detect { file.lineno == lineno }
          end if File.exist?(abs_path)
        end

      /@(\w+)["|'|)]*\.#{@method_name}/ =~ line.to_s && $1
    end
  end

  case RUBY_ENGINE
  when 'ruby'
    require 'did_you_mean/method_receiver'
  when 'jruby'
    require 'did_you_mean/receiver_capturer'
    org.yukinishijima.ReceiverCapturer.setup(JRuby.runtime)
    NoMethodError.send(:attr, :receiver)
  when 'rbx'
    require 'did_you_mean/core_ext/rubinius'
    NoMethodError.send(:attr, :receiver)

    module SimilarMethodFinder::RubiniusSupport
      def self.new(exception)
        if exception.receiver === exception.frame_binding.eval("self")
          NameErrorFinders.new(exception)
        else
          SimilarMethodFinder.new(exception)
        end
      end
    end
  end
end
