require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#require 'em_box'

RSpec.configure do |config|
  config.mock_with :rspec

  config.fail_fast = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

# require helper files
Dir["#{File.dirname(__FILE__)}/example/**/*.rb"].uniq.each do |file|
  require file
end
