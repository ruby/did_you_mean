module DidYouMean
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'did_you_mean' do |app|
      require 'did_you_mean/better_errors' if defined?(::BetterErrors)
    end
  end
end
