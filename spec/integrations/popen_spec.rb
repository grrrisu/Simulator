require 'spec_helper'

describe "popen" do

  before :each do
    @connection  = Sim::Popen::ParentConnection.new
    sim_library = File.expand_path('../../support/popen_test_level.rb', __FILE__)
    level_class = 'PopenTestLevel'
    config_file = File.expand_path('../../level.yml', __FILE__)
    @connection.launch_subprocess(sim_library, level_class)
    @connection.send_action :build, config_file: config_file
  end

  after :each do
    @connection.close
  end

  it "should send a message" do
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should get exception" do
    lambda {
      answer = @connection.send_action :foo
    }.should raise_error(Sim::Popen::RemoteException, 'ArgumentError: unknown message {:action=>"foo"} for PopenTestLevel')
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    answer.should == 'see all the stars'.reverse
  end

  it "should start and stop level" do
    answer = @connection.send_action :start
    answer.should == true
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    answer.should == 'see all the stars'.reverse
    answer = @connection.send_action :stop
    answer.should == true
  end

end
