require 'spec_helper'

describe Sim::Queue::LoopsSupervisor, focus: true do

  let(:config)    { {time_unit: 3, sim_loop: {duration: 5}} } 
  let(:object)    { DummyObject.new }
  let(:time_unit) { Celluloid::Actor[:time_unit]}

  let!(:loops_supervisor) { Sim::Queue::LoopsSupervisor.new(config, [object]) }

  it "should relaunch time unit" do
    prev_actor_id = time_unit.object_id
    expect(time_unit).to be_alive
    allow(time_unit.wrapped_object).to receive(:crash!).and_raise("CRASH")

    time_unit.async.crash!
    binding.pry

    time_unit = Celluloid::Actor[:time_unit]
    expect(time_unit.object_id).to_not be == prev_actor_id
    expect(time_unit).to be_alive
  end

end