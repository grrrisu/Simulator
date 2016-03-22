module Sim
  module Queue
    class FireWorker
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      attr_reader :event_queue

      def initialize event_queue
        @event_queue = event_queue
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
      rescue RuntimeError => e
        monitor event, e
        raise # or retry
      end

      def monitor event, error
        event = {component: :fire_worker, event: event.class.name, error: error.message}
        Actor[:monitor].async.add event
      end

      def shutdown
        debug "shutdown fire worker"
      end

    end
  end
end
