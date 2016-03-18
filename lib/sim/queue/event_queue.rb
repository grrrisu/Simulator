module Sim
  module Queue
    # simple in memory queue
    # we will drop all queued items on shutdown,
    # but should be able to recreate them (sim not player) when resuming
    #
    # ideas for later:
    # * retry mechanism
    # * maybe later we could persist them on Redis
    class EventQueue
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :worker_crashed

      attr_reader :events

      def initialize
        @events = []
        @fire_worker_supervisor = FireWorker.supervise(self)
      end

      def add event
        info "add event #{event.inspect}"
        @events << event
        @fire_worker_supervisor.actors.first.async.run
      end

      def get_event
        @events.shift
      end

      def shutdown
        @events.clear
        @fire_worker_supervisor.terminate
        debug "shutdown event queue"
      end

      def worker_crashed actor, reason
        info "actor #{actor.inspect} dies of #{reason}:#{reason.message}"
      end

    end
  end
end
