module Sim

  class Monitor
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    HISTORY_LENGTH = 10 # seconds

    attr_reader :logs

    def initialize config
      @errors = []
      @events = []
      @subscribers = Set.new
      @timer = nil
    end

    def add_error entry
      entry[time: Time.now]
      @errors << entry
      broadcast_error entry
    end

    def add_event event
      event[time: Time.now]
      @events << event
    end

    def subscribe session_id
      @subscribers << session_id
      broadcast_history unless @timer
    end

    def unsubscribe session_id
      @subscribers.delete session_id
    end

    def broadcast_history
      if @subscribers.any?
        @timer = after(HISTORY_LENGTH) do
          message = {scope: :monitor, action: :history, answer: summary}
          Actor[:broadcaster].async.broadcast_to_sessions @subscribers, message
          broadcast_history
          @events.clear # history lives only for one interval
        end
      else
        @timer = nil
      end
    end

    def summary
      @events.inject({}) do |summary, event|
        summary[event[:name]] ||= 0
        summary[event[:name]] += 1
        summary
      end
    end

    def broadcast_error entry
      message = {scope: :monitor, action: :error, answer: entry}
      Actor[:broadcaster].async.broadcast_to_sessions @subscribers, message
    end

    def shutdown
      debug "shutdown monitor"
    end

  end

end
