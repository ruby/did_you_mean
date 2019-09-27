# frozen-string-literal: true
require 'delegate'
require "did_you_mean/spell_checker"
require "did_you_mean/spell_checkers/name_error_checkers/class_names.rb"

module DidYouMean
  class ClassNameChecker
    include ClassNames

    def initialize(exception)
      @class_name, @receiver, @original_message = exception.name, exception.receiver, exception.original_message
    end

    def corrections
      @corrections ||= SpellChecker.new(dictionary: class_names)
                         .correct(class_name)
                         .map(&:full_name)
                         .reject {|qualified_name| @original_message.include?(qualified_name) }
    end
  end
end
