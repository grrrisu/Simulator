require 'spec_helper'

module Sim
  describe Queue::SimLoop do

    let(:sim_objects)   { %w{a b c d e f}.map{|n| SimulatedObject.new(n)} }
    let(:sim_loop)      { Queue::SimLoop.new(duration: 15, objects: sim_objects) }
    let(:event_queue)   { double(Queue::EventQueue) }

    before :each do
      allow(sim_loop.wrapped_object).to receive(:event_queue).and_return(event_queue)
      allow(Queue::TimeUnit).to receive_message_chain(:instance, time_unit: 1)
    end

    describe "objects" do

      before :each do
        allow(event_queue).to receive(:remove_events)
        allow(sim_loop.wrapped_object).to receive(:stop_time)
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

      it "should sim every object" do
        expect(sim_loop.wrapped_object).to receive(:sim).once
        sim_loop.start
      end

    end

    describe "sim" do

      it "should add object to event queue" do
        expect(event_queue).to receive(:async).once.and_return(event_queue)
        expect(event_queue).to receive(:add).once.with(instance_of(Queue::Event::SimEvent))
        sim_loop.sim
      end

      it "should schedule next sim call" do
        allow(event_queue).to receive_message_chain(:async, :add)
        expect(sim_loop.wrapped_object).to receive(:after).once.with(15 / 6.0)
        sim_loop.sim
      end

      it "should not fire any events but reschedule for next sim" do
        sim_loop = Queue::SimLoop.new(duration: 15, objects: [])
        expect(sim_loop.wrapped_object).to receive(:after).once.with(Queue::SimLoop::TIMEOUT)
        expect(sim_loop.wrapped_object).to receive(:create_event).never
        sim_loop.sim
      end

    end

    describe "objects_count" do

      it "should count objects" do
        sim_loop << Sim::Object.new
        sim_loop << DummyObject.new
        sim_loop << Sim::Object.new
        json = sim_loop.objects_count
        expect(json.keys).to be == ['SimulatedObject', 'Sim::Object', 'DummyObject']
        expect(json.values).to be == [6, 2, 1]
      end

    end

  end
end
