require 'spec_helper'

describe Sim::Queue::SimLoop, focus: true do

  let(:sim_loop) { Sim::Queue::SimLoop.new(15, %w{a b c d e f}) }
  let (:event_queue) { double(Sim::Queue::EventQueue) }

  before :each do
    sim_loop.wrapped_object.stub(:event_queue).and_return(event_queue)
  end

  describe "objects" do

    before :each do
      event_queue.stub(:remove_events)
      sim_loop.wrapped_object.stub(:stop_time)
    end

    it "should loop through all objects and start again" do
      %w{a b c d e f a b c}.each do |expected|
        expect(sim_loop.next_object).to be == expected
      end
    end

    it "should loop through all objects when adding and removing objects" do
      %w{a b}.each do |expected|
        expect(sim_loop.next_object).to be == expected
      end
      sim_loop << 'x'
      sim_loop.remove 'c'
      sim_loop << 'z'
      sim_loop.remove 'a'
      %w{d e f x z b d e}.each do |expected|
        expect(sim_loop.next_object).to be == expected
      end
    end

  end

  describe "sim" do

    before :each do
      sim_loop.wrapped_object.stub(:create_event).and_return('event')
    end

    it "should add object to event queue" do
      event_queue.should_receive(:async).once.and_return(event_queue)
      event_queue.should_receive(:fire).once.with('event')
      sim_loop.sim
    end

    it "should schedule next sim call" do
      event_queue.stub_chain(:async, :fire)
      sim_loop.wrapped_object.should_receive(:after).once.with(15 / 6.0)
      sim_loop.sim
    end

  end

end
