require 'spec_helper'

module Sim
  describe Monitor do

    let(:monitor)     { Monitor.new }
    let(:broadcaster) { Celluloid::Actor[:broadcaster] = Net::Broadcaster.new }
    let(:session)     { Net::Session.new('123') }

    before :each do
      Celluloid::Actor[:sim_master]  = Queue::SimMaster.new
      Celluloid::Actor[:event_queue] = Queue::EventQueue.new
    end

    it "should add a subscriber" do
      expect(monitor.wrapped_object).to receive(:broadcast_history)
      expect(broadcaster).to receive_message_chain(:async, :broadcast_to_sessions)
                             .with(Set.new([session.session_id]), hash_including(scope: :monitor, action: :history))
      expect {
        monitor.subscribe session.session_id
      }.to change { monitor.subscribers.size }.by(1)
    end

    describe 'with a subscriber', focus: true do

      it "should remove a subscriber" do
        expect(broadcaster).to receive(:async).and_return(broadcaster)
        expect(broadcaster).to receive(:broadcast_to_sessions).once
        monitor.subscribe session.session_id

        expect {
          monitor.unsubscribe session.session_id
        }.to change { monitor.subscribers.size }.by(-1)
      end

      it "should inform subscribers about a crash" do
        expect(broadcaster).to receive(:async).and_return(broadcaster).at_least(:once)
        expect(broadcaster).to receive(:broadcast_to_sessions)
                               .with(Set.new([session.session_id]), hash_including(scope: :monitor, action: :history)).ordered
        expect(broadcaster).to receive(:broadcast_to_sessions)
                               .with(Set.new([session.session_id]), hash_including(scope: :monitor, action: :error)).ordered

        monitor.subscribe session.session_id
        error = {event: 'someplace.rb:42', error: 'Error Message'}
        monitor.add_error error
      end

      it "should broadcast_history" do

      end

      it "should gather infos for a snapshot" do

      end
    end

  end
end
