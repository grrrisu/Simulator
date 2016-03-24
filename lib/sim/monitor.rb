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
      entry[time: Time.now]
      @logs << entry
      broadcast entry
    end

    def subscribe session_id
      @subscribers << session_id
    end

    def unsubscribe session_id
      @subscribers.delete session_id
    end

    def broadcast entry
      message = {scope: :monitor, action: :add, answer: entry}
      Actor[:broadcaster].async.broadcast_to_sessions @subscribers, message
    end

    def shutdown
      debug "shutdown monitor"
    end

  end

end
