require 'bundler'
require "bundler/gem_tasks"
Bundler::GemHelper.install_tasks

begin
  require 'rake/extensiontask'

  Rake::ExtensionTask.new('did_you_mean') do |ext|
    ext.name    = "method_missing"
    ext.lib_dir = "lib/did_you_mean"
  end
rescue LoadError
  abort "This Rakefile requires rake-compiler (gem install rake-compiler)"
end

desc "run tests"
task :default => [:test]

desc "Run tests"
task :test do
  Rake::Task['compile'].reenable
  Rake::Task['compile'].invoke

  $stdout.puts("\033[33m")
  sh "bundle exec ruby test/all_test.rb"
  $stdout.puts("\033[0m")

  Rake::Task['clobber'].execute
end

namespace :test do
  desc "Run tests without re-compiling extensions"
  task :without_compile do
    $stdout.puts("\033[33m")
    sh "bundle exec ruby test/all_test.rb"
    $stdout.puts("\033[0m")
  end
end
