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
      trap_exit :worker_supervisor_crashed

      attr_reader :events

      def initialize
        @events = []
        @fire_worker_supervisor = FireWorker.supervise(self)
      end

      def add event
        info "add event #{event}"
        @events << event
        fire_worker.async.run
      end

      def fire_worker
        @fire_worker_supervisor.actors.first
      end

      def get_event
        @events.shift
      end

      def shutdown
        @events.clear
        debug "shutdown event queue"
      end

      def worker_supervisor_crashed actor, reason
        info "actor #{actor.inspect} dies of #{reason}:#{reason.message}"
      end

    end
  end
end
