module Sim
  module Queue

    class SimMaster
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :supervisor_crashed

      def initialize config = {}
        TimeUnit.supervise_as :time_unit, seconds: 10 # timeunit 10 secs
        setup_universe
      end

      def setup_sim_loop duration: 8.0, event_class:
        @sim_loop_supervisor = SimLoop.supervise duration: duration, event_class: event_class
      end

      def setup_universe config = {}
        Universe.supervise_as :universe
      end

      def sim_loop
        @sim_loop_supervisor.actors.first
      end

      def object_size
        return 0 unless @sim_loop_supervisor
        sim_loop.objects.size
      end

      def queue object
        sim_loop.add object
      end

      def start
        Celluloid::Actor[:time_unit].start
        sim_loop.start if @sim_loop_supervisor
      end

      def stop
        Celluloid::Actor[:time_unit].stop
        sim_loop.stop if @sim_loop_supervisor
      end

      def supervisor_crashed actor, reason
        info "actor #{actor.inspect} dies of #{reason}:#{reason.message}"
      end

      def shutdown
        debug "shutdown sim master"
        @sim_loop_supervisor.terminate if @sim_loop_supervisor
      end

    end

  end
end
