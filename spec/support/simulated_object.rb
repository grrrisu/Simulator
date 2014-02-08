class SimulatedObject < Sim::Object
  attr_reader :simulated

  def initialize name
    @name = name
  end

  def sim
    @simulated = true
  end
end
