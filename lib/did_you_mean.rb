require "did_you_mean/version"
require "did_you_mean/core_ext/name_error"
require "did_you_mean/core_ext/no_method_error"
require "did_you_mean/finders"
require "did_you_mean/formatter"

module DidYouMean
  @@trace = TracePoint.new(:raise) do |tp|
    e, b = tp.raised_exception, tp.binding

    if DidYouMean.finders.include?(e.class.to_s) && !e.instance_variable_defined?(:@frame_binding)
      e.instance_variable_set(:@frame_binding, b)
    end
  end
  @@trace.enable

  def self.finders
    @@finders ||= Hash.new(NullFinder)
  end

  finders.merge!({
    "NameError"     => NameErrorFinders,
    "NoMethodError" => MethodFinder
  })
end
