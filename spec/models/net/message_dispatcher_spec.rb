require 'spec_helper'

describe Sim::Net::MessageDispatcher do

  let(:level)       { double(Sim::Level) }
  let(:dispatcher)  { Sim::Net::MessageDispatcher.new(level) }

  describe 'dispatch message' do

    it "should understand start" do
      expect(level).to receive(:start)
      answer = dispatcher.dispatch(action: 'start')
      expect(answer).to eq(true)
    end

    it "should understand stop" do
      expect(level).to receive(:stop)
      answer = dispatcher.dispatch(action: 'stop')
      expect(answer).to eq(true)
    end

    it "should understand create" do
      expect(level).to receive(:build).and_return(true)
      answer = dispatcher.dispatch(action: 'build', params: {config_file: @config_file})
      expect(answer).to eq(true)
    end

    it "should understand load" do
      expect(level).to receive(:load).and_return(true)
      answer = dispatcher.dispatch(action: 'load')
      expect(answer).to eq(true)
    end

    it "should understand add_player" do
      expect(level).to receive(:add_player).with("abc123").and_return(true)
      answer = dispatcher.dispatch(action: 'add_player', params: {id: 'abc123'})
      expect(answer).to eq(true)
    end

    it "should understand remove_player" do
      expect(level).to receive(:remove_player).with("abc123").and_return(true)
      answer = dispatcher.dispatch(action: 'remove_player', params: {id: 'abc123'})
      expect(answer).to eq(true)
    end

    it "should raise error if it doesn't understand the message", skip: true do
      lambda {
        dispatcher.dispatch(action: 'foo')
      }.should raise_error(ArgumentError, 'unknown message {:action=>"foo"}')
    end

  end

end
