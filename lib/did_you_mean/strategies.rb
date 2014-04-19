module DidYouMean
  class NullFinder
    def self.build(*)
      new
    end

    def did_you_mean?; end

    def empty?
      true
    end
  end

  @@strategies = Hash.new(NullFinder)

  def self.strategies
    @@strategies
  end
end

require 'did_you_mean/strategies/similar_name_finder'
require 'did_you_mean/strategies/similar_method_finder'
require 'did_you_mean/strategies/similar_attribute_finder'
