module GameOfLife

  class World < Sim::Matrix::Base

    def initialize size
      super
      set_each_field_with_index do |x, y|
        cell = Cell.new(self, x, y)
        # TODO queue up cells
      end
    end

  end

  class Cell
    attr_accessor :alive
    attr_reader   :x, :y

    def initialize world, x, y
      @world = world
      @x, @y = x, y
    end

    def look_around

    end

  end

end
