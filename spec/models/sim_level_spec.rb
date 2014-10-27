require 'spec_helper'

describe Sim::Level do

  let(:config_file) { File.expand_path('../../level.yml', __FILE__) }
  let(:level)       { DummyLevel.instance }

  describe 'listen_to_parent_process' do

    it "should create a sim queue" do
      Sim::Net::MessageDispatcher.stub_chain(:new, :listen)
      level.listen_to_parent_process('tmp/test.sock')
      Celluloid::Actor[:event_queue].should_not be_nil

    end
  end

  describe 'build' do

    it "should set time unit" do
      level.build(config_file)
      Celluloid::Actor[:time_unit].should_not be_nil
    end

    it "should create an event queue" do
      level.build(config_file)
      Celluloid::Actor[:sim_loop].should_not be_nil
    end

  end

  describe 'that is ready' do

    before :each do
      level.build(config_file)
    end

    describe 'start' do

      it "should start queue" do
        Sim::Queue::Master.should_receive(:start)
        level.start
      end

    end

    describe 'stop' do

      before :each do
        @dispatcher = double('MessageDispatcher')
        level.instance_variable_set('@dispatcher', @dispatcher)
        @dispatcher.stub(:stop)
        Sim::Queue::Master.stub(:stop)
      end

      it "should stop queue" do
        Sim::Queue::Master.should_receive(:stop)
        level.stop
      end

      it "should stop listing to parent process" do
        @dispatcher.should_receive(:stop)
        level.stop
      end

    end

  end

end
