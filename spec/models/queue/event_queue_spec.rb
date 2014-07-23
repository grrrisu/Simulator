require 'spec_helper'

describe Sim::Queue::EventQueue do

  let (:event_queue) { Sim::Queue::EventQueue.new }
  let (:event) { Sim::Queue::SimEvent.new('object') }
  let (:event_2) { Sim::Queue::SimEvent.new('object_2') }
  let (:event_3) { Sim::Queue::SimEvent.new('object_3') }
  let (:fire_workers) { double(Sim::Queue::FireWorker) }

  describe "lock resources" do

    before :each do
      event.stub(:needed_resources).and_return(['A1', 'B1'])
      event_2.stub(:needed_resources).and_return(['A1', 'B2'])
      event_3.stub(:needed_resources).and_return(['A2', 'B2'])
      event_queue.lock_resources(event)
    end

    it "should mark resources of event_2 as locked" do
      expect(event_queue.needed_resources_free?(event_2)).to be false
    end

    it "should mark resources of event_3 as free" do
      expect(event_queue.needed_resources_free?(event_3)).to be true
    end

  end

  describe "release finished events" do

    before :each do
      allow(event).to receive(:done?).and_return(true)
      allow(event_3).to receive(:done?).and_return(false)
      event_queue.instance_variable_set("@processing", [event, event_3])
    end

    it "should remove finished events from processing list" do
      event_queue.release_finished_events
      expect(event_queue.instance_variable_get("@processing").size).to be == 1
    end

    it "should free locked resources" do
      allow(event).to receive(:needed_resources).and_return(['A1', 'B1'])
      allow(event_3).to receive(:needed_resources).and_return(['A2', 'B2'])
      event_queue.lock_resources(event)
      event_queue.lock_resources(event_3)

      event_queue.release_finished_events
      expect(event_queue.instance_variable_get("@locks")).to_not include('A1', 'B1')
      expect(event_queue.instance_variable_get("@locks")).to include('A2', 'B2')
    end

  end

  describe "delegate ready events" do

    before :each do
      allow(fire_workers).to receive(:idle_size).and_return(2)
      allow(fire_workers).to receive_message_chain(:async, :fire)
      allow(event).to receive(:needed_resources).and_return(['A1', 'B1'])
      allow(event_2).to receive(:needed_resources).and_return(['A1', 'B2'])
      allow(event_3).to receive(:needed_resources).and_return(['A2', 'B2'])
      allow(event_queue.wrapped_object).to receive(:fire_workers).and_return(fire_workers)
      event_queue.instance_variable_set("@waitings", [event, event_2, event_3])
    end

    it "should lock resources" do
      event_queue.delegate_ready_events
      expect(event_queue.instance_variable_get("@locks")).to include('A1', 'B1')
      expect(event_queue.instance_variable_get("@locks")).to include('A2', 'B2')
    end

    it "should delegate event to fireworker" do
      allow(fire_workers).to receive(:async).and_return(fire_workers)
      expect(fire_workers).to receive(:fire).once.with(event)
      expect(fire_workers).to receive(:fire).once.with(event_3)
      event_queue.delegate_ready_events
    end

    it "should move ready events to process list" do
      event_queue.delegate_ready_events
      expect(event_queue.instance_variable_get("@processing").size).to be == 2
      expect(event_queue.instance_variable_get("@waitings").size).to be == 1
      expect(event_queue.instance_variable_get("@processing")).to include(event, event_3)
      expect(event_queue.instance_variable_get("@waitings")).to include(event_2)
    end

  end

  describe "run" do

    before :each do
      allow(event_queue.wrapped_object).to receive(:fire_workers).and_return(fire_workers)
      allow(fire_workers).to receive(:idle_size).and_return(2)
      allow(fire_workers).to receive_message_chain(:async, :fire)
    end

    it "should reschedule if an event was blocked" do
      expect(event_queue.wrapped_object).to receive(:after).once
      event_queue.instance_variable_set("@waitings", [event, event_2])
      event_queue.run
    end

    it "should reschedule for cleanup if an event is processed" do
      expect(event_queue.wrapped_object).to receive(:after).once
      event_queue.instance_variable_set("@processing", [event])
      event_queue.run
    end

    it "should not reschedule if no events have been blocked or are processed" do
      expect(event_queue.wrapped_object).to receive(:after).never
      event_queue.run
    end

  end

end
