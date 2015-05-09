require 'bundler/gem_tasks'

case RUBY_ENGINE
when "ruby"
  require 'rake/extensiontask'

  Rake::ExtensionTask.new 'did_you_mean' do |ext|
    ext.name    = "method_receiver"
    ext.lib_dir = "lib/did_you_mean"
  end
when "jruby"
  require 'rake/javaextensiontask'

  Rake::JavaExtensionTask.new 'did_you_mean' do |ext|
    ext.name    = "receiver_capturer"
    ext.lib_dir = "lib/did_you_mean"
  end
end

require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << "test"
  task.pattern = 'test/**/*_test.rb'
  task.verbose = true
  # task.warning = true
end

desc "Run tests"
task test: [:clobber, :compile] if RUBY_ENGINE != 'rbx'
task default: :test
