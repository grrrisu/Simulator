require 'spec_helper'

describe "Sim Queues", focus: true do

  let(:event_queue)   { Celluloid::Actor[:event_queue] }
  let(:sim_loop)      { Celluloid::Actor[:sim_loop] }
  let(:fire_workers)  { Celluloid::Actor[:fire_workers] }

  before :each do
    Sim::Queue::Master.setup nil
  end

  it "should process sim objects" do
    sim_objects = %w{a b c d e x y}.map {|n| SimulatedObject.new(n)}
    Sim::Queue::Master.launch 1, sim_objects[0,5] # launch a b c d e
    Sim::Queue::Master.run!

    Sim::Queue::Master.start
    sim_loop << sim_objects[5] # add x
    sim_loop << sim_objects[6] # add y
    sim_loop.remove sim_objects[0] # remove a
    sim_loop.remove sim_objects[2] # remove c
    # within 1.2 sec all objects should have been simulated
    sleep 1.2
    Sim::Queue::Master.stop
    sim_objects.delete_at 0 # this object may has been removed before simulated
    sim_objects.delete_at 1 # this object may has been removed before simulated
    sim_objects.each do |sim_object|
      expect(sim_object.simulated).to be_true
    end
  end

  it "should process sim object even if they raise execptions" do
    Sim::Queue::Master.launch 1, %w{a b c d e}.map {|n| SimulatedObject.new(n)}
    Sim::Queue::Master.run!

    fire_count = 0
    Sim::Queue::SimEvent.any_instance.stub(:fire) do |arg|
      fire_count += 1
      raise "*** CRASH ***"
    end

    Sim::Queue::Master.start
    sleep 1
    sim_loop.stop
    expect(fire_count).to be >= 5
    expect(event_queue.instance_variable_get("@waitings")).to be_empty
    sleep 0.1
    expect(event_queue.instance_variable_get("@processing")).to be_empty

    event_queue.stop
  end

end
