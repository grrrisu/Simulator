module GameOfLife

  class World < Sim::Matrix::Globe

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
      self
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
      neighbours = []
      (-1..1).each do |dy|
        (-1..1).each do |dx|
          neighbours << @world[x + dx, y + dy] unless dy == 0 && dx == 0
        end
      end
      neighbours
    end

  end

end