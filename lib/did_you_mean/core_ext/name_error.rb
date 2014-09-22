require "binding_of_caller"

class NameError
  begin
    require "active_support/core_ext/name_error"

    def missing_name_without_did_you_mean
      if /undefined local variable or method/ !~ original_message
        $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ original_message
      end
    end if method_defined?(:missing_name)

    alias missing_name_with_did_you_mean missing_name
    alias missing_name missing_name_without_did_you_mean
  rescue LoadError; end

  def set_backtrace_with_exception_lock(*args)
    unless Thread.current[:__did_you_mean_exception_lock]
      Thread.current[:__did_you_mean_exception_lock] = true
      begin
        @__did_you_mean_bindings_stack = binding.callers.drop(1)
      ensure
        Thread.current[:__did_you_mean_exception_lock] = false
      end
    end
    set_backtrace_without_exception_lock(*args)
  end

  alias set_backtrace_without_exception_lock set_backtrace
  alias set_backtrace set_backtrace_with_exception_lock

  def frame_binding
    @frame_binding ||= (@__did_you_mean_bindings_stack || []).first
  end

  def to_s_with_did_you_mean
    original_message + did_you_mean?.to_s
  end

  alias original_message to_s
  alias             to_s to_s_with_did_you_mean

  def did_you_mean?
    method_finder.did_you_mean?
  end

  def method_finder
    @method_finder ||= DidYouMean.strategies[self.class.to_s].new(self)
  end
end
