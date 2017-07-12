module DidYouMean
  module CorrectableRakeTaskManager
    def [](task_name, scopes = nil)
      super
    rescue RuntimeError => error
      begin
        suggestions = ::DidYouMean::SpellChecker.new(dictionary: @tasks.keys).correct(task_name.to_s)
        message     = ::DidYouMean::Formatter.new(suggestions).to_s

        raise error, (error.to_s << message), error.backtrace
      rescue
        raise error, error.to_s, Rake.application.options.trace ? error.backtrace : ''
      end
    end
  end
end

begin
  require 'rake/application'
  Rake::Application.prepend DidYouMean::CorrectableRakeTaskManager
rescue LoadError
end
