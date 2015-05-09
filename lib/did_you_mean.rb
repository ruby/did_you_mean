require "interception"

require "did_you_mean/version"
require "did_you_mean/core_ext/name_error"
require "did_you_mean/finders"
require "did_you_mean/formatters"

module DidYouMean
  Interception.listen do |exception, binding|
    # On IRB/pry console, this event is called twice. In the second event,
    # we get IRB/pry binding. So it shouldn't override @frame_binding if
    # it's already defined.
    if DidYouMean.finders.include?(exception.class.to_s) && !exception.instance_variable_defined?(:@frame_binding)
      exception.instance_variable_set(:@frame_binding, binding)
    end
  end

  @@enabled = true

  def self.enabled?
    @@enabled
  end

  def self.disabled?
    !enabled?
  end

  def self.without_suggestions
    tmp, @@enabled = @@enabled, false
    yield
  ensure
    @@enabled = tmp
  end

  def self.formatter=(formatter)
    @@formatter = formatter
  end

  def self.formatter
    @@formatter ||= Formatters::Plain
  end

  def self.finders
    @@finders ||= Hash.new(NullFinder)
  end

  finders.merge!({
    "NameError"                           => NameErrorFinders,
    "ActiveRecord::UnknownAttributeError" => AttributeFinder,
    "ActiveModel::UnknownAttributeError"  => AttributeFinder,
  })

  case RUBY_ENGINE
  when 'ruby', 'jruby'
    finders["NoMethodError"] = MethodFinder
  when 'rbx'
    finders["NoMethodError"] =
      if (___ rescue $!).class.to_s == "NameError" # For rbx > 2.5.0
        MethodFinder
      else
        MethodFinder::RubiniusSupport              # For rbx < 2.5.0
      end
  end
end
