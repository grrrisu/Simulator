module Sim
  module Queue

    class SimMaster
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      def initialize config = {}
        TimeUnit.supervise_as :time_unit, seconds: 10 # timeunit 10 secs
        @sim_loop_supervisor = SimLoop.supervise 8.0
      end

      def start
        Celluloid::Actor[:time_unit].start
        @sim_loop_supervisor.actors.first.start
      end

      def stop
        Celluloid::Actor[:time_unit].stop
        @sim_loop_supervisor.actors.first.stop
      end

      def shutdown
        debug "shutdown sim master"
        @sim_loop_supervisor.terminate
      end

    end

  end
end
