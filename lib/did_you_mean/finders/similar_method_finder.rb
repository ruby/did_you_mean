require 'ostruct'

module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception, base_class_name = nil)
      @method_name = exception.name
      @receiver    = exception.receiver
      @original_message = exception.original_message
      @base_class_name = base_class_name
    end

    def words
      (receiver.methods + receiver.singleton_methods).uniq.map do |name|
        StringDelegator.new(name.to_s, :method, prefix: prefix)
      end
    end

    def suggestions
      methods = @base_class_name ? super.map(&:with_prefix) : super
      methods + similar_classes_method_suggestions
    end

    alias target_word method_name

    private

    def prefix
      @prefix ||= begin
        separator = @base_class_name.to_s
        separator << (receiver_is_class_or_method? ? DOT : POUND)
      end
    end

    def receiver_is_class_or_method?
      @receiver.is_a?(Class) || @receiver.is_a?(Module)
    end

    def similar_classes_method_suggestions
      return [] unless receiver_is_class_or_method? && !@base_class_name
      similar_class_suggestions.flat_map do |suggestion|
        SimilarMethodFinder.new(*similar_method_finder_params(suggestion.to_s)).suggestions
      end
    end

    def similar_method_finder_params(class_name)
      exception = OpenStruct.new(
        name: @method_name,
        receiver: Kernel.const_get(class_name),
        original_message: @original_message
      )
      [exception, class_name]
    end

    def similar_class_suggestions
      exception = OpenStruct.new original_message: @original_message.gsub(/:(Module|Class)$/, '')
      SimilarClassFinder.new(exception).suggestions
        .select do |suggestion|
          const = Kernel.const_get(suggestion.to_s)
          (const.is_a?(Class) || const.is_a?(Module)) && suggestion.to_s != @receiver.to_s
        end
        .map(&:with_prefix)
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
