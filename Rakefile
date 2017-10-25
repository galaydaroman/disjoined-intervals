require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: [:rubocop, :spec]

desc 'Run IRB console'
task :console do
  require 'pry'
  require 'disjoined_intervals'
  pry
end
