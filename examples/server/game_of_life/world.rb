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

end
