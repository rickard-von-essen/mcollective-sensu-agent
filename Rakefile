RAKE_ROOT = File.expand_path(File.dirname(__FILE__))
specdir = File.join([File.dirname(__FILE__), "spec"])

require 'rake'
begin
  require 'rspec/core/rake_task'
  require 'mcollective'
rescue LoadError
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--color"
end

task :test do
  require "#{specdir}/spec_helper.rb"
end

task :default => :spec
