require 'did_you_mean/finders/similar_class_method_finder'

module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception, similar_class_name = nil)
      @method_name = exception.name
      @receiver    = exception.receiver
      @exception = exception
      @similar_class = similar_class_name || ''
    end

    def words
      (receiver.methods + receiver.singleton_methods).uniq.map do |name|
        StringDelegator.new(name.to_s, :method, prefix: prefix)
      end
    end

    def suggestions
      if @similar_class.empty?
        super + similar_class_method_suggestions
      else
        super.map(&:with_prefix)
      end
    end

    alias target_word method_name

    private

    def prefix
      @prefix ||= @similar_class + separator
    end

    def separator
      receiver_is_module_or_class? ? DOT : POUND
    end

    def receiver_is_module_or_class?
      receiver.is_a?(Module) || receiver.is_a?(Class)
    end

    def similar_class_method_suggestions
      return [] unless receiver_is_module_or_class?
      SimilarClassMethodFinder.new(@exception).suggestions
    end

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
