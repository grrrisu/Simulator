class Simulator
  attr_reader :object

  def initialize object
    @object = object
  end

  def sim
    object.calculate 3.1
  end

end
