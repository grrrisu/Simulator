require 'spec_helper'

describe "Sim Queues", focus: true do

  let(:event_queue)   { Celluloid::Actor[:event_queue] }
  let(:sim_loop)      { Celluloid::Actor[:sim_loop] }
  let(:fire_workers)  { Celluloid::Actor[:fire_workers] }

  before :each do
    Sim::Queue::Master.setup nil
    Sim::Queue::Master.launch 1, %w{a b c d e}
    Sim::Queue::Master.run!
  end

  it "should process sim objects" do
    fire_count = 0
    Sim::Queue::SimEvent.any_instance.stub(:fire) do |arg|
      fire_count += 1
    end

    Sim::Queue::Master.start
    sim_loop << 'x'
    sim_loop << 'y'
    sim_loop.remove 'a'
    sim_loop.remove 'c'
    sleep 1
    Sim::Queue::Master.stop
    # within 1 sec all 5 objects should have been simulated
    expect(fire_count).to be >= 5
  end

  it "should process sim object even if they raise execptions" do
    fire_count = 0
    Sim::Queue::SimEvent.any_instance.stub(:fire) do |arg|
      fire_count += 1
      raise "*** CRASH ***"
    end

    Sim::Queue::Master.start
    sim_loop << 'x'
    sim_loop << 'y'
    sim_loop.remove 'a'
    sim_loop.remove 'c'

    sleep 1
    expect(fire_count).to be >= 5
    sim_loop.stop
    expect(event_queue.instance_variable_get("@waitings")).to be_empty
    sleep 0.1
    expect(event_queue.instance_variable_get("@processing")).to be_empty

    event_queue.stop
    #sleep 1
    # within 1 sec all 5 objects should have been simulated

  end

end
