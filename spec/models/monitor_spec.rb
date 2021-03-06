require 'spec_helper'

module Sim
  RSpec.describe Monitor do

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

    describe 'with a subscriber' do

      before :each do
        expect(broadcaster).to receive(:async).and_return(broadcaster).at_least(:once)
      end

      it "should remove a subscriber" do
        expect(broadcaster).to receive(:broadcast_to_sessions).once
        monitor.subscribe session.session_id

        expect {
          monitor.unsubscribe session.session_id
        }.to change { monitor.subscribers.size }.by(-1)
      end

      it "should inform subscribers about a crash" do
        expect(broadcaster).to receive(:broadcast_to_sessions)
                               .with(Set.new([session.session_id]), hash_including(scope: :monitor, action: :history)).ordered
        expect(broadcaster).to receive(:broadcast_to_sessions)
                               .with(Set.new([session.session_id]), hash_including(scope: :monitor, action: :error)).ordered

        monitor.subscribe session.session_id
        error = {event: 'someplace.rb:42', error: 'Error Message'}
        monitor.add_error error
      end

      it "should calculate events summary" do
        monitor.subscribe session.session_id

        3.times { monitor.add_event name: 'one' }
        5.times { monitor.add_event name: 'two' }
        2.times { monitor.add_event name: 'three' }

        summary = monitor.summary
        expect(summary['one']).to eq(3)
        expect(summary['two']).to eq(5)
        expect(summary['three']).to eq(2)
      end

    end

    it "should gather infos for a snapshot" do
      snapshot = monitor.snapshot
      expect(snapshot).to be == {
        session_size: 0,
        event_size: 0,
        object_size: 0,
        time_unit: 0.0
      }
    end

  end
end
