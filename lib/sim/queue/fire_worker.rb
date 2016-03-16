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
      end

      def shutdown
        debug "shutdown fire worker"
      end

    end
  end
end
