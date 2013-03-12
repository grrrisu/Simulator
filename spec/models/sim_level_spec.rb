require 'spec_helper'

describe Sim::Level do

  before :each do
    @config_file = File.expand_path('../../level.yml', __FILE__)
    @level = Sim::Level.new(@config_file)
  end

  describe 'build' do

    it "should set time unit" do
      @level.build(@config_file)
      Celluloid::Actor[:time_unit].should_not be_nil
    end

    it "should create a queue" do
      @level.build(@config_file)
      @level.wrapped_object.instance_variable_get('@queue').should_not be_nil
    end

  end

  describe 'process message' do

    it "should understand start" do
      @level.wrapped_object.should_receive(:start)
      @level.process_message('start').should be_true
    end

    it "should understand stop" do
      @level.wrapped_object.should_receive(:stop)
      @level.process_message('stop').should be_true
    end

    it "should raise error if it doesn't understand the message", skip: true do
      lambda {
        @level.process_message('foo')
      }.should raise_error(ArgumentError, "unknown message foo")
    end

  end

  describe 'start' do

    it "should start queue" do
      @level.wrapped_object.instance_variable_get('@queue').should_receive(:start)
      @level.start
    end

  end

  describe 'stop', skip: true do

    it "should stop queue" do
      @level.wrapped_object.instance_variable_get('@queue').should_receive(:stop)
      @level.stop
    end

    it "should stop listing to parent process" do
      process = mock('SubProcess')
      @level.instance_variable_set('@process', process)
      process.should_receive(:stop)
      @level.stop
    end

  end

end
