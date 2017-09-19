require 'did_you_mean/undefined_method_detector'

project_dir = Dir.pwd

at_exit {
  UndefinedMethodDetector.new(project_dir).undefined_methods.each do |undefined_method|
    undefined_method.called_by.each do |caller|
      puts "`#{undefined_method.name}` seems undefined but is called at #{caller.source_location[0]}:#{undefined_method.lineno}"
    end
  end
}

module Kernel
  def at_exit
    # no-op
  end
end
