require 'ostruct'

module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @original_message = exception.original_message
      @separator   = @receiver.is_a?(Class) ? DOT : POUND
    end

    def words
      (receiver.methods + receiver.singleton_methods).uniq.map do |name|
        StringDelegator.new(name.to_s, :method, prefix: @separator)
      end
    end

    def suggestions
      super + similar_classes
    end

    alias target_word method_name

    private

    def similar_classes
      return [] unless @receiver.is_a?(Class)
      similar_class = SimilarClassFinder.new(OpenStruct.new name: @receiver, original_message: @original_message)
      similar_class.suggestions.map(&:with_prefix).
        select { |suggestion| Kernel.const_get(suggestion.to_s).respond_to? @method_name }.
        map do |delegator|
        StringDelegator.new("#{delegator.to_s}.#@method_name" , :method)
      end
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
