unless ENV['SIM_ENV'] == 'test'
  require 'jeweler'
  require_relative '../lib/sim'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
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
end
