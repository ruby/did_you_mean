module DidYouMean
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'did_you_mean' do |app|
      if defined?(::BetterErrors) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "2.0.0"
        require 'did_you_mean/better_errors'
      end
    end
  end
end
