require 'did_you_mean/undefined_method_detector'

at_exit {
  UndefinedMethodDetector.new(__dir__)
    .undefined_methods
    .each { |undefined_method|
      undefined_method.called_by.each do |method_calling_undefined_method|
        puts "`#{undefined_method.name}` seems undefined but is called at #{method_calling_undefined_method.source_location.join(":")}"
      end
    }
}

module Kernel
  def at_exit
    # no-op
  end
end
