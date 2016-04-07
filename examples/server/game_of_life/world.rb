module GameOfLife

  class World < Sim::Matrix::Base

    def initialize size
      super
    end

    def create
      srand
      set_each_field_with_index do |x, y|
        cell = Cell.new(self, x, y)
        cell.alive = rand(4) == 0
        cell
      end
    end

  end

  class Cell
    attr_accessor :alive
    attr_reader   :x, :y

    def initialize world, x, y
      @world = world
      @x, @y = x, y
      queue_up
    end

    def queue_up
      Celluloid::Actor[:sim_master].queue self
    end

    def to_json(*args)
      {x: x, y: y, alive: alive}.to_json
    end

    def look_around

    end

  end

end
