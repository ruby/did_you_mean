require_relative "../spell_checker"

module DidYouMean
  class KeyErrorChecker
    def initialize(key_error)
      @key = key_error.key
      @keys = key_error.receiver.keys
    end

    def corrections
      @corrections ||= similar_keys + SpellChecker.new(dictionary: @keys).correct(@key).map(&:inspect)
    end

    private

    def similar_keys
      @keys.select { |word| @key == word.to_s }.map(&:inspect)
    end
  end
end
