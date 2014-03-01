begin
  require "binding_of_caller"
rescue LoadError => e
  puts "could not load binding_of_caller. please make sure it is included in the Gemfile."
  raise e
end

class NameError
  begin
    require "active_support/core_ext/name_error"

    if method_defined?(:missing_name)
      def missing_name_without_did_you_mean
        if /undefined local variable or method/ !~ original_message
          $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ original_message
        end
      end

      alias missing_name_with_did_you_mean missing_name
      alias missing_name missing_name_without_did_you_mean
    end
  rescue LoadError
  end

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

  def to_s_with_did_you_mean
    original_to_s + did_you_mean?.to_s
  end

  alias original_to_s to_s
  alias          to_s to_s_with_did_you_mean
  alias original_message original_to_s

  def did_you_mean?
    return if !undefined_local_variable_or_method? || (similar_methods.empty? && similar_local_variables.empty?)

    output = "\n\n"
    output << "   Did you mean?\n"

    unless similar_methods.empty?
      output << "     instance methods: ##{similar_methods.first}\n"
      output << similar_methods[1..-1].map{|word| "#{' ' * 23}##{word}\n" }.join
    end

    output << "\n" if !similar_methods.empty? && !similar_local_variables.empty?

    unless similar_local_variables.empty?
      output << "      local variables: ##{similar_local_variables.map.first}\n"
      output << similar_local_variables[1..-1].map{|word| "#{' ' * 23}##{word}\n" }.join
    end

    output
  end

  def similar_methods
    @similar_methods ||= DidYouMean::MethodFinder.new(frame_binding.eval("methods"), name).similar_methods
  end

  def similar_local_variables
    @similar_local_variables ||= DidYouMean::MethodFinder.new(frame_binding.eval("local_variables"), name).similar_methods
  end

  def undefined_local_variable_or_method?
    original_to_s.include?("undefined local variable or method")
  end

  def frame_binding
    @frame_binding ||= __did_you_mean_bindings_stack.first
  end
end
