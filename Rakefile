require "bundler/gem_tasks"

begin
  #require 'rake/extensiontask'
  #Rake::ExtensionTask.new('did_you_mean') do |ext|
  #  ext.lib_dir = "lib/did_you_mean"
  #end
rescue LoadError
  abort "This Rakefile requires rake-compiler (gem install rake-compiler)"
end

dlext = RbConfig::CONFIG['DLEXT']


desc "run tests"
task :default => [:test]

desc "Run tests"
task :test do
  Rake::Task['compile'].execute

  $stdout.puts("\033[33m")
  sh "bundle exec ruby test/all_test.rb"
  $stdout.puts("\033[0m")

  Rake::Task['cleanup'].execute
end

desc "build the binaries"
task :compile do
  chdir "./ext/did_you_mean" do
    sh "ruby extconf.rb"
    sh "make"
    sh "cp *.#{dlext} ../../lib/did_you_mean"
  end
end

desc 'cleanup the extensions'
task :cleanup do
  sh 'rm -rf lib/did_you_mean/method_missing.so'
  chdir "./ext/did_you_mean/" do
    sh 'make clean'
  end
end
