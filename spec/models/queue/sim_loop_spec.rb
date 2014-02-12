require 'spec_helper'

describe Sim::Queue::SimLoop do

  let(:sim_objects) { %w{a b c d e f}.map{|n| SimulatedObject.new(n)} }
  let(:sim_loop) { Sim::Queue::SimLoop.new(15, sim_objects) }
  let (:event_queue) { double(Sim::Queue::EventQueue) }

  before :each do
    sim_loop.wrapped_object.stub(:event_queue).and_return(event_queue)
    Sim::TimeUnit.stub_chain(:instance, :time_unit).and_return(1)
  end

  describe "objects" do

    before :each do
      event_queue.stub(:remove_events)
      sim_loop.wrapped_object.stub(:stop_time)
    end

    it "should loop through all objects and start again" do
      %w{a b c d e f a b c}.each do |expected|
        expect(sim_loop.next_object.name).to be == expected
      end
    end

    it "should loop through all objects when adding and removing objects" do
      %w{a b}.each do |expected|
        expect(sim_loop.next_object.name).to be == expected
      end
      sim_loop << SimulatedObject.new('x')
      sim_loop.remove sim_objects[2]
      sim_loop << SimulatedObject.new('z')
      sim_loop.remove sim_objects[0]
      %w{d e f x z b d e}.each do |expected|
        expect(sim_loop.next_object.name).to be == expected
      end
    end

    it "should touch every object" do
      sim_objects.each {|obj| obj.should_receive(:touch)}
      sim_loop.wrapped_object.should_receive(:sim).once
      sim_loop.start
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
