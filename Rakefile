require 'bundler/gem_tasks'

if RUBY_ENGINE == "ruby"
  require 'rake/extensiontask'

  Rake::ExtensionTask.new 'did_you_mean' do |ext|
    ext.name    = "method_receiver"
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
task test: [:clobber, :compile] if RUBY_ENGINE == 'ruby'
task default: :test
