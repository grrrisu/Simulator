require 'spec_helper'

module Sim
  describe 'should process a message' do

    let(:socket)     { double('Socket') }
    let(:connection) { Net::PlayerConnection.new(socket) }

    before(:each) do
      Sim::Net::Router.define {|router| router.forward :test, to: Example::SimpleHandler }
      Celluloid::Actor[:event_queue] = Queue::EventQueue.new
      Celluloid::Actor[:message_dispatcher] = Net::MessageDispatcher.new
      Celluloid::Actor[:broadcaster] = Net::Broadcaster.new
    end

    it "and return the reversed text" do
      expect(socket).to receive(:print).with('{"scope":"test","action":"reverse","answer":"dlrow olleh"}')
      connection.receive '{"scope":"test","player_id":123,"action":"reverse","args":"hello world"}'
      sleep 0.1
    end

  end
end
