# frozen-string-literal: true

module DidYouMean
  module Correctable
    def original_message
      method(:to_s).super_method.call
    end

    def to_s
      msg = super.dup
      suggestion = DidYouMean.formatter.message_for(suggestions)

      msg << suggestion if !msg.end_with?(suggestion)
      msg
    rescue
      super
    end

    def suggestions
      @suggestions ||= spell_checker.yield_self do |checker|
                         if checker.respond_to?(:suggestions)
                           checker.suggestions
                         else
                           # warn "Did you mean now requires the spell checker to respond to #suggestions instead " \
                           #      "of #suggestions. Please rename it to #suggestions."

                           checker.corrections
                         end
                       end
    end

    def corrections
      # warn "The #corrections method is deprecated in favor of #suggestions. Please call the #suggestions method " \
      #      "instead."

      suggestions
    end

    def spell_checker
      SPELL_CHECKERS[self.class.to_s].new(self)
    end
  end
end
