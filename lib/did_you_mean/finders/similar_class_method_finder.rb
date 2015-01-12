require 'ostruct'

module DidYouMean
  class SimilarClassMethodFinder

    def initialize(exception)
      @method_name = exception.name
      @receiver    = exception.receiver
      @original_message = exception.original_message
    end

    def suggestions
      return [] unless receiver_is_class_or_method?
      similar_class_suggestions.flat_map do |suggestion|
        SimilarMethodFinder.new(*similar_method_finder_params(suggestion.to_s)).suggestions
      end
    end

    private

    def receiver_is_class_or_method?
      @receiver.is_a?(Class) || @receiver.is_a?(Module)
    end

    def similar_class_suggestions
      SimilarClassFinder.new(similar_class_suggestions_exception).suggestions
        .select { |suggestion| is_similar_class?(suggestion.to_s) }
        .map(&:with_prefix)
    end

    def is_similar_class?(class_name)
      return false if is_receiver_class?(class_name)
      const = Kernel.const_get(class_name)
      const.is_a?(Class) || const.is_a?(Module)
    end

    def is_receiver_class?(class_name)
      class_name == @receiver.to_s
    end


    def similar_class_suggestions_exception
      OpenStruct.new original_message: @original_message.gsub(/:(Module|Class)$/, '')
    end

    def similar_method_finder_params(class_name)
      exception = OpenStruct.new(
        name: @method_name,
        receiver: Kernel.const_get(class_name),
        original_message: @original_message
      )
      [exception, class_name]
    end

  end
end
