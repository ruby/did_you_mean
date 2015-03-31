require 'bundler/gem_tasks'

namespace :test do
  desc "Run tests without re-compiling extensions"
  task :without_compile do
    begin
      $stdout.puts "\033[33m"
      sh "bundle exec ruby -w test/all_test.rb"
    ensure
      $stdout.puts "\033[0m"
    end
  end
end

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

desc "Run tests"
if RUBY_ENGINE != 'rbx'
  task test: [:compile, "test:without_compile", :clobber]
else
  task test: "test:without_compile"
end
task default: :test
