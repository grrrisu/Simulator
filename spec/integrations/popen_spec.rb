require 'spec_helper'

describe "popen", focus: true do

  before :each do
    @connection   = Sim::Net::ParentConnection.new
    sim_library   = File.expand_path('../../support/dummy_level.rb', __FILE__)
    level_class   = 'DummyLevel'
    level_config  = File.expand_path('../../../config/level.yml', __FILE__)
    config_file   = File.expand_path('../../level.yml', __FILE__)
    @connection.launch_subprocess(sim_library, level_class, level_config, 'test')
    @connection.send_action :build, config_file: config_file
  end

  after :each do
    @connection.close
  end

  it "should send a message" do
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    expect(answer).to be == 'see all the stars'.reverse
  end

  it "should get exception" do
    expect {
      answer = @connection.send_action :foo
    }.to raise_error(Sim::Net::RemoteException, 'ArgumentError: unknown message {:action=>"foo"} for DummyLevel')
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    expect(answer).to be == 'see all the stars'.reverse
  end

  it "should start and stop level" do
    answer = @connection.send_action :start
    expect(answer).to be == true
    answer = @connection.send_action :reverse, msg: 'see all the stars'
    expect(answer).to be == 'see all the stars'.reverse
    answer = @connection.send_action :stop
    expect(answer).to be == true
  end

end
