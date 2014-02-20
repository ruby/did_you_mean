module DidYouMean
  module NoMethodErrorExtension
    def receiver
      args.first
    end

    def self.included(base)
      base.class_eval do
        alias all_backtrace backtrace
        alias backtrace backtrace_without_unneeded_lines
      end
    end

    def backtrace_without_unneeded_lines
      all_backtrace.reject do |line|
        line.include?("lib/did_you_mean/core_ext/object.rb")
      end if all_backtrace.is_a?(Array)
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
