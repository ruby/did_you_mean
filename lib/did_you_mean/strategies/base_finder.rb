module DidYouMean
  class BaseFinder
    def new(*)
      raise NotImplementedError, "DidYouMean::BaseFinder is an abstract class"
    end

    def did_you_mean?
      return if empty?

      output = "\n\n"
      output << "    Did you mean? #{format(similar_words.first)}\n"
      output << similar_words[1..-1].map{|word| "#{' ' * 18}#{format(word)}\n" }.join
      output
    end

    def similar_words
      @similar_words ||= WordCollection.new(words).similar_to(target_word)
    end

    def empty?
      similar_words.empty?
    end
  end
end
