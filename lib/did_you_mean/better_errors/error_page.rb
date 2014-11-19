module DidYouMean
  module BetterErrors
    def self.template_path
      File.join("/", __dir__, "template.erb")
    end

    def self.template
      Erubis::EscapedEruby.new(File.read(template_path))
    end

    module ErrorPageExtension
      prepend_features ::BetterErrors::ErrorPage

      def do_variables(opts)
        result = super
        error  = @exception.exception

        if error.is_a?(NameError) && error.did_you_mean?
          @suggestions = error.suggestions
          @formatter   = error.finder

          result[:html].prepend DidYouMean::BetterErrors.template.result(binding)

          remove_instance_variable :@suggestions
          remove_instance_variable :@formatter
        end

        result
      end
    end
  end
end
