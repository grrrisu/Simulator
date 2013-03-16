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
    answer = @connection.send_message action: 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should get exception" do
    lambda {
      answer = @connection.send_message action: 'foo'
    }.should raise_error(Sim::Popen::RemoteException, 'unknown message {"action"=>"foo"}')
    answer = @connection.send_message action: 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should start and stop level" do
    answer = @connection.send_message action: 'start'
    answer.should == true
    answer = @connection.send_message action: 'see all the stars'
    answer.should == 'see all the stars'.reverse
    answer = @connection.send_message action: 'stop'
    answer.should == true
  end

end
