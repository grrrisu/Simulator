require 'spec_helper'

describe Sim::Player do

  let(:player)        { Sim::Player.new(123, 'level') }
  let(:connection)    { double Sim::Net::PlayerConnection }
  let(:event_queue)   { double Sim::Queue::EventQueue }

  before(:each) do
    player.connection = connection
    player.class.instance_eval do
      define_method :direct_actions do
        [:subito]
      end
    end
    allow(Celluloid::Actor).to receive(:[]).with(:event_queue) { event_queue }
    allow(event_queue).to receive_message_chain(:async, :fire)
  end

  it "should bypass queue" do
    expect(connection).to receive(:send_message).with(:subito, 'subito result').once
    expect(player).to receive(:subito).with(1, 2, 3).and_return('subito result').once
    expect(event_queue).to receive(:async).never
    player.process_message(:subito, a: 1, b: 2, c: 3)
  end

  it "should action event to queue" do
    expect(event_queue).to receive(:async).once
    expect(connection).to receive(:send_message).never
    player.process_message(:later, a: 5, b: 4, c: 3)
  end

end
