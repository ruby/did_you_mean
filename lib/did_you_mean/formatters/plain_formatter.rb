# frozen-string-literal: true

module DidYouMean
  # The +DidYouMean::PlainFormatter+ is the basic, default formatter for the
  # gem. The formatter responds to the +message_for+ method and it returns a
  # human readable string.
  class PlainFormatter

    # Returns a human readable string that contains +suggestions+. This
    # formatter is designed to be less verbose to not take too much screen
    # space while being helpful enough to the user.
    #
    # @example
    #
    #   formatter = DidYouMean::PlainFormatter.new
    #
    #   # displays suggestions in two lines with the leading empty line
    #   puts formatter.message_for(["methods", "method"])
    #
    #   Did you mean?  methods
    #                   method
    #   # => nil
    #
    #   # displays an empty line
    #   puts formatter.message_for([])
    #
    #   # => nil
    #
    def message_for(suggestions)
      suggestions.empty? ? "" : "\nDid you mean?  #{suggestions.join("\n               ")}"
    end
  end
end
