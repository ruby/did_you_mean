require 'did_you_mean/undefined_method_detector'
require 'json'

PAYLOAD = {
  ruby_engine: RUBY_ENGINE,
  ruby_version: RUBY_VERSION,
  ruby_description: RUBY_DESCRIPTION,
  did_you_mean_version: DidYouMean::VERSION
}

at_exit {
  PAYLOAD['undefined_names'] = UndefinedMethodDetector.new(__dir__)
    .undefined_methods
    .flat_map do |undefined_method|
      undefined_method.called_by.map do |method_calling_undefined_method|
        {
          "undefined_name": undefined_method.name,
          "symbol_type": "method",
          "path": "#{__dir__}/#{method_calling_undefined_method.source_location[0]}",
          "lineno": method_calling_undefined_method.source_location[1]
        }
      end
    end

  puts JSON.pretty_generate(PAYLOAD)
}

module Kernel
  def at_exit
    # no-op
  end
end
