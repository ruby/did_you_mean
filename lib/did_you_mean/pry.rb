module DidYouMean
  module Pry
    def self.enable
      ::Pry.config.exception_handler = exception_handler(::Pry.config.exception_handler)
    end

    def self.disable
      ::Pry.config.exception_handler = ::Pry::DEFAULT_EXCEPTION_HANDLER
    end

    def self.exception_handler(original_handler)
      ->(output, exception, _) {
        begin
          org, DidYouMean.formatter =
            DidYouMean.formatter, DidYouMean::Formatters::Pry

          original_handler.call(output, exception, _)
        ensure
          DidYouMean.formatter = org
        end
      }
    end
  end
end

DidYouMean::Pry.enable
