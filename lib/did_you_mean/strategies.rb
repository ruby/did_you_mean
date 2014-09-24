module DidYouMean
  class NullFinder
    def initialize(*);     end
    def did_you_mean?;     end
    def similar_words; []; end
  end

  @@strategies = Hash.new(NullFinder)

  def self.strategies
    @@strategies
  end
end

require 'did_you_mean/strategies/base_finder'
require 'did_you_mean/strategies/name_error_strategies'
require 'did_you_mean/strategies/similar_method_finder'
require 'did_you_mean/strategies/similar_attribute_finder'
