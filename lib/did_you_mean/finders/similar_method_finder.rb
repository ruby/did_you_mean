module DidYouMean
  class SimilarMethodFinder
    include BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name, @receiver = exception.name, exception.receiver
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
      require 'did_you_mean/method_receiver'
    when 'jruby'
      require 'did_you_mean/receiver_capturer'
      org.yukinishijima.ReceiverCapturer.setup(JRuby.runtime)
      NoMethodError.send(:attr, :receiver)
    when 'rbx'
      require 'did_you_mean/core_ext/rubinius'
      NoMethodError.send(:attr, :receiver)

      module SimilarMethodFinder::RubiniusSupport
        def self.new(exception)
          if exception.receiver === exception.frame_binding.eval("self")
            NameErrorFinders.new(exception)
          else
            SimilarMethodFinder.new(exception)
          end
        end
      end

      finders["NoMethodError"] = SimilarMethodFinder::RubiniusSupport
    else
      finders.delete("NoMethodError")
    end
  end
end
