require 'rubygems'
require 'bundler/setup'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

ENV['SIM_ENV'] ||= 'test'

require 'celluloid'
require 'celluloid/rspec'
require 'timecop'

require_relative '../lib/sim'

# Terminate the default incident reporter and replace it with one that logs to a file
logfile = File.open(File.expand_path("../../log/test.log", __FILE__), 'a')

Celluloid.logger.level = Logger::WARN

Dir['./spec/support/*.rb'].map {|f| require f }
# example code
Dir['./examples/event/*.rb'].map {|f| require f }
Dir['./examples/message_handler/*.rb'].map {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run :focus => true
  config.filter_run_excluding :skip => true
  config.run_all_when_everything_filtered = true

  # config.before(:each) do
  #   Celluloid.logger = nil
  #   Celluloid.shutdown
  #   Celluloid.boot
  # end

end
