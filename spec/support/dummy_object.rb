class DummyObject < Sim::Object
  attr_reader :name, :size

  def initialize
    super()
    @size = 0
  end

  def calculate delay
    @size += delay * 10
  end

end
