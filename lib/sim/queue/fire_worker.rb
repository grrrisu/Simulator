module Sim
  module Queue
    class FireWorker
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      attr_reader :event_queue

      def initialize event_queue
        @event_queue = event_queue
        run
      end

      def run
        if event = event_queue.get_event
          process event
          async.run
        end
      end

      def process event
        debug "process event #{event.inspect}"
        event.fire # later maybe retry
        monitor_processed event
      rescue RuntimeError => e
        monitor_error event, e
        raise # or retry
      end

      def monitor_processed event
        event = {name: event.class.name}
        Actor[:monitor].async.add_event event
      end

      def monitor_error event, error
        event = {component: :fire_worker, event: event.class.name, error: error.message}
        Actor[:monitor].async.add_error event
      end

      def shutdown
        debug "shutdown fire worker"
      end

    end
  end
end
