module DidYouMean
  module BaseFinder
    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "    Did you mean? #{format(similar_words.first)}\n"
      output << similar_words[1..-1].map{|word| "#{' ' * 18}#{format(word)}\n" }.join
      output << " " # for pry
    end

    def similar_words
      @similar_words ||= WordCollection.new(words).similar_to(target_word)
    end

    def empty?
      similar_words.empty?
    end
  end

  class NullFinder
    def initialize(*); end
    def did_you_mean?; end
  end

  @@strategies = Hash.new(NullFinder)

  def self.strategies
    @@strategies
  end
end

require 'did_you_mean/strategies/name_error_strategies'
require 'did_you_mean/strategies/similar_method_finder'
require 'did_you_mean/strategies/similar_attribute_finder'
