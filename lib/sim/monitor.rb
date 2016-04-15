module Sim

  class Monitor
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    HISTORY_LENGTH = 10 # seconds

    attr_reader :logs

    def initialize config = {}
      @errors = []
      @events = []
      @subscribers = Set.new
      @timer = nil
    end

    def add_error entry
      return if @subscribers.empty?
      entry[time: Time.now]
      @errors << entry
      broadcast_error entry
    end

    def add_event event
      return if @subscribers.empty?
      event[time: Time.now]
      @events << event
    end

    def subscribe session_id
      @subscribers << session_id
      broadcast_history unless @timer
      send_history
    end

    def unsubscribe session_id
      @subscribers.delete session_id
      @events.clear if @subscribers.empty?
    end

    def broadcast_history
      if @subscribers.any?
        @timer = after(HISTORY_LENGTH) do
          send_history
          broadcast_history
          @events.clear # history lives only for one interval
        end
      else
        @timer = nil
      end
    end

    def send_history
      message = {scope: :monitor, action: :history, summary: summary, snapshot: snapshot }
      Actor[:broadcaster].async.broadcast_to_sessions @subscribers, message
    end

    def snapshot
      event_size  = Celluloid::Actor[:event_queue].future.events
      session_size = Net::Session.session_size
      object_size = Celluloid::Actor[:sim_master].future.object_size
      time_unit   = Celluloid::Actor[:time_unit].zero_or_time_elapsed
      {
        session_size: session_size,
        event_size: event_size.value.size,
        object_size: object_size.value,
        time_unit: time_unit
      }
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
