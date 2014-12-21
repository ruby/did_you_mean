class NameError
  attr_reader :frame_binding

  WHITE_LISTED_CALLERS = %w{safe_constantize}

  begin
    require "active_support/core_ext/name_error"

    def missing_name
      if /undefined local variable or method/ !~ original_message
        $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ original_message
      end
    end if method_defined?(:missing_name)
  rescue LoadError; end

  def to_s_with_did_you_mean
    return original_message if caller_is_whitelisted?
    original_message + did_you_mean?.to_s rescue original_message
  end

  alias original_message to_s
  alias             to_s to_s_with_did_you_mean

  def did_you_mean?
    finder.did_you_mean?
  end

  def finder
    @finder ||= DidYouMean.finders[self.class.to_s].new(self)
  end

  private

  def caller_is_whitelisted?
    backtrace_methods.any?{ |method| WHITE_LISTED_CALLERS.include? method }
  end

  def backtrace_methods
    regex_parse_trace = /^(.+?):(\d+)(|:in `(.+)')$/
    exception.backtrace.map{ |trace| trace.match(regex_parse_trace)[4] }.uniq
  end
end
