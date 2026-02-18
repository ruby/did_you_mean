# frozen_string_literal: true

# Patches IRB's eval_input to capture the last failed code and exception
# when a Did you mean? correctable error occurs.

module DidYouMean
  module IRB
    module EvalPatch
      def eval_input
        configure_io

        each_top_level_statement do |statement, line_no|
          signal_status(:IN_EVAL) do
            begin
              if @context.with_debugger && statement.should_be_handled_by_debugger?
                return statement.code
              end

              @context.evaluate(statement, line_no)

              if @context.echo? && !statement.suppresses_echo?
                if statement.is_assignment?
                  if @context.echo_on_assignment?
                    output_value(@context.echo_on_assignment? == :truncate)
                  end
                else
                  output_value
                end
              end
            rescue SystemExit, SignalException
              raise
            rescue Interrupt, Exception => exc
              # Store for fix command when it's a Correctable error
              if exc.respond_to?(:corrections) && !exc.corrections.to_a.empty?
                LastError.store(statement.code, exc, line_no)
              else
                LastError.clear
              end
              handle_exception(exc)
              if DidYouMean::IRB::FixCommand.fixable?
                puts "\e[2mType `fix` to rerun with the correction.\e[0m"
              end
              @context.workspace.local_variable_set(:_, exc)
            end
          end
        end
      end
    end
  end
end

# Prepend our module to override eval_input
::IRB::Irb.prepend(DidYouMean::IRB::EvalPatch)
