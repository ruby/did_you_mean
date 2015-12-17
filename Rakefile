require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << "test"
  task.pattern = 'test/**/*_test.rb'
  task.verbose = true
  task.warning = true
end

Rake::TestTask.new("test:verbose_formatter") do |task|
  task.libs << "test"
  task.pattern = 'test/verbose_formatter_test.rb'
  task.verbose = true
  task.warning = true
  task.ruby_opts << "-rdid_you_mean/verbose_formatter"
end

task default: :test

namespace :test do
  namespace :accuracy do
    desc "Download Wiktionary's Simple English data and save it as a dictionary"
    task :prepare do
      sh 'ruby evaluation/dictionary_generator.rb'
    end
  end

  desc "Calculate accuracy of the gems' spell checker"
  task :accuracy do
    if !File.exist?("evaluation/dictionary.yml")
      puts 'Generating dictionary for evaluation:'
      Rake::Task["test:accuracy:prepare"].execute
      puts "\n"
    end

    sh 'bundle exec ruby evaluation/calculator.rb'
  end
end

namespace :benchmark do
  desc "Measure memory usage by the did_you_mean gem"
  task :memory do
    sh 'bundle exec ruby benchmark/memory_usage.rb'
  end
end
