class SimulatedObject < Sim::Object
  attr_reader :name, :simulated

  def initialize name, crash = false
    super()
    @simulated = 0
    @name = name
    @crash = crash
  end

  def to_s
    "SimObject #{@name}"
  end

  def calculate
    @simulated += 1
    raise "*** CRASH ***" if @crash
  end
end
