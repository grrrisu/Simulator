require 'spec_helper'

describe Sim::Queue::LoopsSupervisor do

  let(:config)    { {time_unit: 3, sim_loop: {duration: 5}} }
  let(:object)    { DummyObject.new }
  let(:time_unit) { Celluloid::Actor[:time_unit] }
  let(:sim_loop)  { Celluloid::Actor[:sim_loop] }

  let!(:loops_supervisor) { Celluloid::Actor[:loops_supervisor] = Sim::Queue::LoopsSupervisor.new(config, [object]) }

  it "should relaunch time unit" do
    prev_actor_id = time_unit.object_id
    expect(time_unit).to be_alive
    allow(time_unit.wrapped_object).to receive(:crash!).and_raise("CRASH")

    time_unit.async.crash!
    sleep 0.1

    time_unit = Celluloid::Actor[:time_unit]
    expect(time_unit.object_id).to_not be == prev_actor_id
    expect(time_unit).to be_alive
  end

  it "should relaunch sim loop" do
    prev_actor_id = sim_loop.object_id
    expect(sim_loop).to be_alive
    allow(sim_loop.wrapped_object).to receive(:crash!).and_raise("CRASH")

    sim_loop.async.crash!
    sleep 0.1

    sim_loop = Celluloid::Actor[:sim_loop]
    expect(sim_loop.object_id).to_not be == prev_actor_id
    expect(sim_loop).to be_alive
  end

end
