module Sim
  class Level
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :sessions

    def initialize
      info "level init"
      @sessions = {}
    end

    def add_session session
      @sessions[session.player_id] = session
    end

    def remove_session player_id
      @sessions.delete player_id
      debug "session #{player_id} removed"
    end

    def find_session player_id
      @sessions[player_id]
    end

    def create
      raise "implement in subclass"
    end

    def shutdown
      @sessions.clear
      info "level shutdown"
    end

  end
end
