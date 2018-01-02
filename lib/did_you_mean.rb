require "did_you_mean/version"
require "did_you_mean/core_ext/name_error"

require "did_you_mean/spell_checker"
require 'did_you_mean/spell_checkers/name_error_checkers'
require 'did_you_mean/spell_checkers/method_name_checker'
require 'did_you_mean/spell_checkers/key_error_checker'
require 'did_you_mean/spell_checkers/null_checker'

require "did_you_mean/formatters/plain_formatter"

module DidYouMean
  SPELL_CHECKERS = Hash.new(NullChecker)
  SPELL_CHECKERS.merge!({
    "NameError"     => NameErrorCheckers,
    "NoMethodError" => MethodNameChecker,
    "KeyError"      => KeyErrorChecker
  })

  NameError.prepend DidYouMean::Correctable
  KeyError.prepend DidYouMean::Correctable

  def self.formatter
    @@formatter
  end

  def self.formatter=(formatter)
    @@formatter = formatter
  end

  self.formatter = PlainFormatter.new
end
