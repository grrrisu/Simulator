module Sim

  class Player
    attr_accessor :connection, :current_view_dimension
    attr_reader   :level, :id

    def initialize id, level
      @id     = id
      @level  = level
    end

    def direct_actions
      []
    end

    def process_message action, params
      if direct_actions.include? action
        # actions like init_map, view
        connection.send_message action, send(action, *params.values)
      else
        # actions that need global look and/or be evented, eg move
        fire_action_event(action, params)
      end
    end

    def fire_action_event action, params
      event = Queue::ActionEvent.new self, action, params
      event_queue = Celluloid::Actor[:event_queue]
      event_queue.async.fire(event)
    end

  end

end
