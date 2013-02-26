require 'rubygems'
require 'bundler/setup'
require 'celluloid'
require 'celluloid/rspec'
require 'timecop'

require_relative '../lib/sim'

# Terminate the default incident reporter and replace it with one that logs to a file
logfile = File.open(File.expand_path("../../log/test.log", __FILE__), 'a')
Celluloid::Actor[:default_incident_reporter].silence
Celluloid::IncidentReporter.supervise_as :test_incident_reporter, logfile

Dir['./lib/*.rb'].map {|f| require f unless f =~ /main\.rb/ }
Dir['./spec/support/*.rb'].map {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.fail_fast = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
