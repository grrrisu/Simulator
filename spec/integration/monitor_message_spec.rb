require 'spec_helper'

module Sim
  describe 'monitor' do

    let(:socket)     { double('Socket') }
    let(:connection) { Net::PlayerConnection.new(socket) }

    before(:each) do
      Sim::Net::Router.define {|router| router.forward :example, to: Example::Handler }
      Sim::Net::Router.define {|router| router.forward :monitor, to: Net::MessageHandler::Monitor }

      Celluloid::Actor[:monitor] = Monitor.new
      Celluloid::Actor[:sim_master] = Queue::SimMaster.new
      Celluloid::Actor[:event_queue] = Queue::EventQueue.new
      Celluloid::Actor[:message_dispatcher] = Net::MessageDispatcher.new
      Celluloid::Actor[:broadcaster] = Net::Broadcaster.new
    end

    it "should subscribe" do
      expect(socket).to receive(:puts).with('{"scope":"monitor","action":"history","summary":{},"snapshot":{"session_size":1,"event_size":0,"object_size":0,"time_unit":0.0}}')
      connection.receive '{"scope":"monitor","player_id":123,"action":"subscribe"}'
      sleep 0.1
    end

    it "should report a crash" do
      allow(socket).to receive(:puts).once # the first history event after subscribing
      connection.receive '{"scope":"monitor","player_id":123,"action":"subscribe"}'
      expect(socket).to receive(:puts).with(/\{"scope":"monitor","action":"error","answer":\{"event":.*,"error":"Oh Snap!"\}\}/)
      connection.receive '{"scope":"example","player_id":123,"action":"crash"}'
      sleep 0.1
    end

    it "should unsubscribe" do
      allow(socket).to receive(:puts).with(/\{"scope":"monitor","action":"history",.*\}/)
      connection.receive '{"scope":"monitor","player_id":123,"action":"subscribe"}'

      expect(socket).to receive(:puts).never.with(/\{"scope":"monitor","action":"error","answer":\{"event":.*,"error":"Oh Snap!"\}\}/)
      connection.receive '{"scope":"monitor","player_id":123,"action":"unsubscribe"}'
      connection.receive '{"scope":"example","player_id":123,"action":"crash"}'
      sleep 0.1
    end

  end
end
