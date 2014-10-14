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

    # TODO this method can be called by different threads
    # by the player_connection for incoming messages
    # and by the event_broadcaster to update the view
    # -> should therefore Player become an Actor?
    # -> if yes how handle errors?
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

    # override in sub class
    def overlap_current_view?
      true
    end

    def needed_resources_for action, params
      [] # none
    end

  end

end
