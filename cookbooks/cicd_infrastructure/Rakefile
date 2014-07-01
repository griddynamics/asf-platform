# Encoding: utf-8
require 'bundler/setup'

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  require 'foodcritic'
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

require 'kitchen'
desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.with_friendly_errors
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

require 'rspec/core/rake_task'
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t, args|
  t.rspec_opts = 'test/unit/spec'
end

desc "Runs knife cookbook test"
task :syntax do
  sh "rbenv exec bundle exec knife cookbook test #{File.basename(Dir.getwd)} -o .."
end

# The default rake task should just run it all
task default: ['syntax' ,'style']
# Disable all test for now
# task default: ['syntax' ,'style', 'spec', 'integration']


begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
