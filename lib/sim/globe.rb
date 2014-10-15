module Sim
  class Globe < Matrix

    # returns a position within the bounderies, stopping at the bounderies
    def check_bounderies x, y
      x = width() -1 if x < 0
      y = height() -1 if y < 0
      x = 0 if x >= width
      y = 0 if y >= height
      [x, y]
    end

    # returns a position within the bounderies going around the world
    def around_position x, y
      # Array[] handles negative index until -size
      if (0...width) === x && (0...height) === y
        [x, y]
      else
        if x >= width
          x -= width
        elsif x < 0
          x += width
        end
        if y >= height
          y -= height
        elsif y < 0
          y += height
        end
        around_position x, y
      end
    end

    def get_field x, y
      super(*around_position(x, y))
    end
    alias [] get_field

    def set_field x, y, value
      super(*around_position(x, y), value)
    end
    alias []= set_field

  end
end
