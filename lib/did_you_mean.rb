require "did_you_mean/version"
require "did_you_mean/core_ext/name_error"

require "did_you_mean/spell_checkable"
require 'did_you_mean/spell_checkers/name_error_checkers'
require 'did_you_mean/spell_checkers/method_name_checker'
require 'did_you_mean/spell_checkers/null_checker'

require "did_you_mean/formatter"

module DidYouMean
  @@trace = TracePoint.new(:raise) do |tp|
    e, b = tp.raised_exception, tp.binding

    if DidYouMean.spell_checkers.include?(e.class.to_s) && !e.instance_variable_defined?(:@frame_binding)
      e.instance_variable_set(:@frame_binding, b)
    end
  end
  @@trace.enable

  IGNORED_CALLERS = [
    /( |`)missing_name'/,
    /( |`)safe_constantize'/
  ]

  def self.spell_checkers
    @@spell_checkers ||= Hash.new(NullChecker)
  end

  spell_checkers.merge!({
    "NameError"     => NameErrorCheckers,
    "NoMethodError" => MethodNameChecker
  })
end
