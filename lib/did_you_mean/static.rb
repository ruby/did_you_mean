require 'did_you_mean/undefined_method_detector'
require 'json'

PAYLOAD = {
  ruby_engine: RUBY_ENGINE,
  ruby_version: RUBY_VERSION,
  ruby_description: RUBY_DESCRIPTION,
  did_you_mean_version: DidYouMean::VERSION
}

current_dir = Dir.pwd

at_exit {
  detector = UndefinedMethodDetector.new(current_dir)

  PAYLOAD[:undefined_names] = detector
    .undefined_methods
    .flat_map { |undefined_method|
      undefined_method.called_by.map do |method_calling_undefined_method|
        path = method_calling_undefined_method.source_location[0]
        path = File.join(current_dir, path) if !path.start_with?(current_dir)

        {
          undefined_name: undefined_method.name,
          symbol_type: "method",
          path: path,
          lineno: undefined_method.lineno,
          "suggestions": DidYouMean::SpellChecker.new(dictionary: detector.all_defined_method_names).correct(undefined_method.name).uniq
        }
      end
    }
    .uniq
    .group_by {|method_info| method_info[:lineno] }

  puts JSON.pretty_generate(PAYLOAD)
}

module Kernel
  def at_exit
    # no-op
  end
end
