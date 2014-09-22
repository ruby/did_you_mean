require 'did_you_mean/strategies/null_finder'
require 'did_you_mean/strategies/base_finder'

module DidYouMean
  @@strategies = Hash.new(NullFinder)

  def self.strategies
    @@strategies
  end
end

require 'did_you_mean/strategies/name_error_strategies'
require 'did_you_mean/strategies/similar_method_finder'
require 'did_you_mean/strategies/similar_attribute_finder'
