module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name, @receiver = exception.name, exception.args.first
    end

    def words
      (receiver.methods + receiver.singleton_methods).uniq
    end

    alias target_word method_name

    def format(word)
      "#{separator}#{word}"
    end

    def class_method?
      receiver.is_a? Class
    end

    def separator
      class_method? ? "." : "#"
    end
  end

  if defined?(RUBY_ENGINE)
    finders["NoMethodError"] = SimilarMethodFinder

    case RUBY_ENGINE
    when 'ruby'
      require 'did_you_mean/method_missing'
    when 'jruby'
      require 'did_you_mean/receiver_capturer'
      org.yukinishijima.ReceiverCapturer.setup(JRuby.runtime)
    else
      finders.delete("NoMethodError")
    end
  end
end
