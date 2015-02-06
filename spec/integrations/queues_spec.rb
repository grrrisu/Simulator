require 'spec_helper'

describe "Sim Queues" do

  let(:level)         { double(Sim::Level) }
  let(:config)        { {time_unit: 1, sim_loop: {duration: 1} } }
  let(:event_queue)   { Celluloid::Actor[:event_queue] }
  let(:sim_loop)      { Celluloid::Actor[:sim_loop] }
  let(:fire_workers)  { Celluloid::Actor[:fire_workers] }

  before :each do
    allow(level).to receive(:config).and_return(config)
    #Sim::Queue::Master.setup 'level'
  end

  it "should process sim objects" do
    sim_objects = %w{a b c d e x y}.map {|n| SimulatedObject.new(n)}
    Sim::Queue::Master.launch level, sim_objects[0,5] # launch a b c d e

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
      expect(sim_object.simulated).to be > 0
    end
  end

  it "should process sim object even if they raise execptions" do
    sim_objects = %w{a b c d e}.map {|n| SimulatedObject.new(n, true)}
    Sim::Queue::Master.launch level, sim_objects

    Sim::Queue::Master.start
    sleep 1
    sim_loop.stop
    sim_objects.each do |sim_object|
      expect(sim_object.simulated).to be > 0
    end
    expect(event_queue.instance_variable_get("@waitings")).to be_empty
    sleep 0.1
    expect(event_queue.instance_variable_get("@processing")).to be_empty

    event_queue.stop
  end

end
