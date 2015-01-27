module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
    end

    def words
      method_names = receiver.methods + receiver.singleton_methods
      method_names.delete(method_name)
      method_names.uniq.map {|name| MethodName.new(name.to_s) }
    end

    alias target_word method_name
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
