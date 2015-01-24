module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @separator   = @receiver.is_a?(Class) ? DOT : POUND
    end

    def words
      method_names = receiver.methods + receiver.singleton_methods
      method_names.delete(@method_name)
      method_names.uniq.map do |name|
        StringDelegator.new(name.to_s, :method, prefix: @separator)
      end
    end

    alias target_word method_name
  end

  finders["NoMethodError"] = SimilarMethodFinder

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

    finders["NoMethodError"] = SimilarMethodFinder::RubiniusSupport
  else
    finders.delete("NoMethodError")
  end
end
