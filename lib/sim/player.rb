module Sim

  class Player
    attr_accessor :connection
    attr_reader   :level, :id

    def initialize connection, level
      @connection = connection
      @level      = level
    end

    def register data
      raise "implement in subclass"
    end

  end

end
