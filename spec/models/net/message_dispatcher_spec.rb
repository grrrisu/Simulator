require 'spec_helper'

describe Sim::Net::MessageDispatcher do

  let(:level)       { double(Sim::Level) }
  let(:dispatcher)  { Sim::Net::MessageDispatcher.new(level) }

  describe 'dispatch message' do

    it "should understand start" do
      level.should_receive(:start)
      dispatcher.dispatch(action: 'start').should be true
    end

    it "should understand stop" do
      level.should_receive(:stop)
      dispatcher.dispatch(action: 'stop').should be true
    end

    it "should understand create" do
      level.should_receive(:build).and_return(true)
      dispatcher.dispatch(action: 'build', params: {config_file: @config_file}).should be true
    end

    it "should understand load" do
      level.should_receive(:load).and_return(true)
      dispatcher.dispatch(action: 'load').should be true
    end

    it "should understand add_player" do
      level.should_receive(:add_player).with("abc123").and_return(true)
      dispatcher.dispatch(action: 'add_player', params: {id: 'abc123'}).should be true
    end

    it "should understand remove_player" do
      level.should_receive(:remove_player).with("abc123").and_return(true)
      dispatcher.dispatch(action: 'remove_player', params: {id: 'abc123'}).should be true
    end

    it "should raise error if it doesn't understand the message", skip: true do
      lambda {
        dispatcher.dispatch(action: 'foo')
      }.should raise_error(ArgumentError, 'unknown message {:action=>"foo"}')
    end

  end

end
