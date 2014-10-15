require 'spec_helper'

describe Sim::Queue::ActionEvent do

  describe 'fire' do

    let(:player)            { double(Sim::Player) }
    let(:connection)        { double(Sim::Net::PlayerConnection) }
    let(:event_broadcaster) { double(Sim::Queue::EventBroadcaster) }
    let(:event)             { Sim::Queue::ActionEvent.new(player, :action, param: 'one') }
    let(:answer)            { {answer: 42, notify: 'me'} }

    before(:each) do
      allow(Celluloid::Actor).to receive(:[]).with(:event_broadcaster).and_return(event_broadcaster)
      allow(player).to receive(:action).and_return(answer)
      allow(player).to receive(:connection).and_return(connection)
      allow(player).to receive(:current_view_dimension).and_return('current_view_dimension')
      allow(connection).to receive(:send_message)
      allow(event_broadcaster).to receive(:async).and_return(event_broadcaster)
      allow(event_broadcaster).to receive(:notify)
    end

    it "should execute action on player" do
      expect(player).to receive(:action).with('one')
      event.fire
    end

    it "should send answer to player" do
      expect(connection).to receive(:send_message).with(:action, answer)
      event.fire
    end

    it "should notify listeners" do
      expect(event_broadcaster).to receive(:notify).with('me', player)
      event.fire
    end

  end

end
