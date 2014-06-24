module Sim

  class Player
    attr_accessor :connection
    attr_reader   :level, :id

    def initialize connection, level
      @connection = connection
      @level      = level
    end

    def register data
      @id = data[:player_id]
      level.add_player self
      connection.send_data(player_id: @id, registered: true)
    end

  end

end
