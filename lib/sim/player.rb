module Sim

  class Player
    attr_accessor :connection, :current_view_dimension
    attr_reader   :level, :id

    def initialize id, level
      @id     = id
      @level  = level
      @alive  = true
    end

    # TODO this method can be called by different threads
    # by the player_connection for incoming messages
    # and by the event_broadcaster to update the view
    # -> should therefore Player become an Actor?
    # -> if yes how handle errors?
    def process_message action, params
      answer = send(action, *params.values)
      unless answer.nil?
        # if we got an answer than we can send it directly back
        # otherwise the answer will be sent by the action async
        connection.send_message action, answer
      end
    end

    def fire_action_event event
      event_queue = Celluloid::Actor[:event_queue]
      event_queue.async.fire(event)
    end

    # override in sub class
    def overlap_current_view?
      true
    end

    def alive?
      @alive
    end

  end

end
