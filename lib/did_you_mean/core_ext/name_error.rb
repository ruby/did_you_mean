begin
  require "binding_of_caller"
  binding_of_caller_available = true
rescue LoadError => e
  binding_of_caller_available = false
end

if binding_of_caller_available
  class NameError
    original_set_backtrace = instance_method(:set_backtrace)

    define_method :set_backtrace do |*args|
      unless Thread.current[:__did_you_mean_exception_lock]
        Thread.current[:__did_you_mean_exception_lock] = true
        begin
          @__did_you_mean_bindings_stack = binding.callers.drop(1)
        ensure
          Thread.current[:__did_you_mean_exception_lock] = false
        end
      end
      original_set_backtrace.bind(self).call(*args)
    end
  
    def __did_you_mean_bindings_stack
      @__did_you_mean_bindings_stack || []
    end
  end
end
