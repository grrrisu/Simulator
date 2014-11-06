require 'spec_helper'

describe Sim::Level do

  let(:level_config)  { File.expand_path('../../../config/level.yml', __FILE__)}
  let(:config_file)   { File.expand_path('../../level.yml', __FILE__) }
  let(:level)         { DummyLevel.instance }

  describe 'listen_to_parent_process' do

    it "should create a sim queue" do
      allow(Sim::Net::MessageDispatcher).to receive_message_chain(:new, :listen)
      level.load_config(level_config)
      level.setup
      expect(Celluloid::Actor[:event_queue]).to_not be_nil
    end
  end

  describe 'build' do

    it "should set time unit" do
      level.build(config_file)
      expect(Celluloid::Actor[:time_unit]).to_not be_nil
    end

    it "should create an event queue" do
      level.build(config_file)
      expect(Celluloid::Actor[:sim_loop]).to_not be_nil
    end

  end

  describe 'that is ready' do

    before :each do
      level.build(config_file)
    end

    describe 'start' do

      it "should start queue" do
        expect(Sim::Queue::Master).to receive(:start)
        level.start
      end

    end

    describe 'stop' do

      before :each do
        @dispatcher = double('MessageDispatcher')
        level.instance_variable_set('@dispatcher', @dispatcher)
        allow(@dispatcher).to receive(:stop)
        allow(Sim::Queue::Master).to receive(:stop)
      end

      it "should stop queue" do
        expect(Sim::Queue::Master).to receive(:stop)
        level.stop
      end

      it "should stop listing to parent process" do
        expect(@dispatcher).to receive(:stop)
        level.stop
      end

    end

  end

end
