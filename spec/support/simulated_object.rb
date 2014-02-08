class SimulatedObject < Sim::Object
  attr_reader :name, :simulated

  def initialize name
    super()
    @name = name
  end

  def to_s
    "SimObject #{@name}"
  end

  def sim
    @simulated = true
  end
end
