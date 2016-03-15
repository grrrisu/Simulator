module Sim
  class Level
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :players

    def initialize
      info "level init"
      @players = {}
    end

    def add_player player
      @players[player.id] = player
    end

    def remove_player player_id
      @players.delete player_id
      debug "player #{player_id} removed"
    end

    def find_player player_id
      @players[player_id]
    end

    def shutdown
      @players.clear
      info "level shutdown"
    end

  end
end
