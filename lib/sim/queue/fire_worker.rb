module Sim
  module Queue

    class FireWorker
      include Celluloid
      include Celluloid::Logger

      def fire event
        event.fire
      ensure
        # so that the event will be removed from the processing list of the event_queue
        # TODO may add a retry mechanism or let the event queue handle it
        event.done!
      end

    end

  end
end
