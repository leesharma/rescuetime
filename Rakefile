#!/usr/bin/env rake

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task test: :spec

defaults = [:spec]

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
  # defaults << :rubocop
rescue LoadError
  puts 'Rubocop is not installed; please install it for code quality checks.'
end

desc "Run default actions: #{defaults}"
task default: defaults
