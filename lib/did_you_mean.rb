require "did_you_mean/version"
require "did_you_mean/core_ext/name_error"

require "did_you_mean/spell_checkable"
require 'did_you_mean/spell_checkers/name_error_checkers'
require 'did_you_mean/spell_checkers/method_name_checker'
require 'did_you_mean/spell_checkers/null_checker'

require "did_you_mean/formatter"

module DidYouMean
  TRACE = TracePoint.new(:raise) do |tp|
    e = tp.raised_exception

    if SPELL_CHECKERS.include?(e.class.to_s) && !e.instance_variable_defined?(:@frame_binding)
      e.instance_variable_set(:@frame_binding, tp.binding)
    end
  end

  IGNORED_CALLERS = []

  SPELL_CHECKERS = Hash.new(NullChecker)
  SPELL_CHECKERS.merge!({
    "NameError"     => NameErrorCheckers,
    "NoMethodError" => MethodNameChecker
  })
end
