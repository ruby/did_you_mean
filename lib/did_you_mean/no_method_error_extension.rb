require 'did_you_mean/object_extension'

module DidYouMean
  module NoMethodErrorExtension
    attr_reader :receiver

    def message
      super + did_you_mean?
    end

    def did_you_mean?
      return if similar_methods.empty?

      output = "\n\n"
      output << "Did you mean?" << "\n"
      output << similar_methods.map{|word| "\t#{receiver_name}#{separator}#{word}" }.join("\n") << "\n"
      output << "\n"
    end

    def similar_methods
      @similar_methods ||= (receiver.methods + receiver.singleton_methods).uniq.select do |method|
        ::Text::Levenshtein.distance(method.to_s, name.to_s) <= 2
      end
    end

    private

    def receiver_name
      class_method? ? receiver.name : receiver.class.name
    end

    def separator
      class_method? ? "." : "#"
    end

    def class_method?
      receiver.is_a? Class
    end
  end
end

NoMethodError.send :include, DidYouMean::NoMethodErrorExtension
