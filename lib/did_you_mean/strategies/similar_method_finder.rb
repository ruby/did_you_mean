module DidYouMean
  class SimilarMethodFinder < BaseFinder
    attr_reader :method_name, :receiver

    def initialize(exception)
      @method_name, @receiver = exception.name, exception.args.first
    end

    def word_collection
      receiver.methods + receiver.singleton_methods
    end

    alias similar_methods similar_words
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

  strategies["NoMethodError"] = SimilarMethodFinder
end
