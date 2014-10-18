class SimulatedObject < Sim::Object
  attr_reader :name, :simulated

  default_attr :sim_threshold, 0.0

  def initialize name, crash = false
    super()
    @simulated = 0
    @name = name
    @crash = crash
    @sim_threshold = 0.0
  end

  def to_s
    "SimObject #{@name}"
  end

  def calculate delay
    @simulated += 1
    raise "*** CRASH ***" if @crash
  end
end
