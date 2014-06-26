module Sim

  class Player
    attr_accessor :connection
    attr_reader   :level, :id

    def initialize id, level
      @id     = id
      @level  = level
    end

  end

end
