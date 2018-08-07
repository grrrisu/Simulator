require 'spec_helper'

module Sim
  describe Queue::SimEvent do

    it "should sim object once" do
      simulator = Simulator.new(SimulatedObject.new('abc'))
      event = Queue::SimEvent.new(simulator)
      expect(simulator.object.simulated).to be == 0
      event.fire
      expect(simulator.object.simulated).to be == 1
    end

  end
end
