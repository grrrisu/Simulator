require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  require_relative '../lib/sim/version.rb'
  version = Sim::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Simulator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
