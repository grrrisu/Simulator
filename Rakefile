# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  puts e.message
  puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require_relative 'lib/sim'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "Simulator"
  gem.version = Sim::VERSION
  gem.homepage = "http://github.com/grrrisu/Simulator"
  gem.license = "MIT"
  gem.summary = %Q{A simulation container based on Celluloid}
  gem.description = %Q{A simulation container based on Celluloid}
  gem.email = "adm@m42.ch"
  gem.authors = ["Alessandro Di Maria"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  #version = File.exist?('VERSION') ? File.read('VERSION') : ""
  version = Sim::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Simulator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
