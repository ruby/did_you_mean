# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'did_you_mean/version'

Gem::Specification.new do |spec|
  spec.name          = "did_you_mean"
  spec.version       = DidYouMean::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["mail@yukinishijima.net"]
  spec.summary       = %q{Did you mean? in your ruby app}
  spec.description   = %q{When you made a typo or forgot the correct spelling and got NoMethodError and NameError, this gem tells you the right one you are looking for.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "text"
  spec.add_dependency "binding_of_caller"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
