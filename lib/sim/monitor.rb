module Sim

  class Monitor
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :logs

    def initialize config
      @logs = []
      @subscribers = Set.new
    end

    def add entry
      @logs << entry
      broadcast entry
    end

    def subscribe player_id
      @subscribers << player_id
    end

    def unsubscribe player_id
      @subscribers.delete player_id
    end

    def broadcast entry
      message = {scope: :monitor, action: :add, answer: entry}
      Actor[:broadcaster].async.broadcast @subscribers, message
    end

    def shutdown
      debug "shutdown monitor"
    end

  end

end
