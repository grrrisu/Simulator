require 'spec_helper'

describe "popen" do

  before :each do
    @connection  = Sim::Popen::ParentConnection.new
    sim_library = File.expand_path('../../support/popen_test_level.rb', __FILE__)
    level_class = 'PopenTestLevel'
    config_file = File.expand_path('../../level.yml', __FILE__)
    @connection.start(sim_library, level_class, config_file)
  end

  after :each do
    @connection.close
  end

  it "should send a message" do
    answer = @connection.send_message 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should get exception" do
    answer = @connection.send_message 'foo'
    answer.should == "exception 'unknown message foo' occured in subprocess"
    answer = @connection.send_message 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should start and stop level" do
    answer = @connection.send_message 'start'
    answer.should == "true"
    answer = @connection.send_message 'see all the stars'
    answer.should == 'see all the stars'.reverse
    answer = @connection.send_message 'stop'
    answer.should == "true"
  end

end
