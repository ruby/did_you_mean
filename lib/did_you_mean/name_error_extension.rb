module DidYouMean
  module NameErrorExtension
    def self.included(base)
      base.class_eval do
        alias original_to_s to_s
        alias          to_s to_s_with_did_you_mean

        alias original_message original_to_s

        begin
          require "active_support/core_ext/name_error"
          if method_defined?(:missing_name)
            alias missing_name_with_did_you_mean missing_name
            alias missing_name missing_name_without_did_you_mean
          end
        rescue LoadError; end
      end
    end

    def missing_name_without_did_you_mean
      if /undefined local variable or method/ !~ original_message
        $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ original_message
      end
    end

    def to_s_with_did_you_mean
      original_to_s + did_you_mean?.to_s
    end

    def did_you_mean?
      return if !undefined_local_variable_or_method? || (similar_methods.empty? && similar_local_variables.empty?)

      output = "\n\n"
      output << "Did you mean?" << "\n"

      unless similar_methods.empty?
        output << "    instance methods:" << "\n"
        output << similar_methods.map{|word| "\t##{word}" }.join("\n") << "\n"
        output << "\n"
      end

      unless similar_local_variables.empty?
        output << "    local variables:" << "\n"
        output << similar_local_variables.map{|word| "\t#{word}" }.join("\n") << "\n"
        output << "\n"
      end

      output
    end

    def similar_methods
      @similar_methods ||= _methods.uniq.select do |method|
        ::Text::Levenshtein.distance(method.to_s, name.to_s) <= 2
      end
    end

    def similar_local_variables
      @similar_local_variables ||= _local_variables.uniq.select do |method|
        ::Text::Levenshtein.distance(method.to_s, name.to_s) <= 2
      end
    end

    private

    def undefined_local_variable_or_method?
      original_to_s.include?("undefined local variable or method")
    end

    def _methods
      @_methods ||= frame_binding.eval("methods")
    end

    def _local_variables
      @_local_variables ||= frame_binding.eval("local_variables")
    end

    def frame_binding
      @frame_binding ||= __did_you_mean_bindings_stack.detect do |binding|
        !binding.eval("__FILE__").include?("lib/did_you_mean/core_ext/object.rb")
      end
    end
  end
end

NameError.send :include, DidYouMean::NameErrorExtension
