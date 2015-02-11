module Sim
  module Queue

    class LoopsSupervisor
      include Celluloid
      include Celluloid::Logger

      trap_exit :actor_died

      attr_reader :config

      def initialize config, sim_objects
        launch config, sim_objects
      end

      def stop
        terminate
      end

      def launch config, sim_objects
        #this queues will NOT be restarted automaticaly if they crash
        unless Celluloid::Actor[:time_unit].try(:alive?)
          Celluloid::Actor[:time_unit] = TimeUnit.new_link config[:time_unit]
        end
         
        unless Celluloid::Actor[:sim_loop].try(:alive?)
          duration = config[:time_unit] * config[:sim_loop][:duration]
          Celluloid::Actor[:sim_loop]  = SimLoop.new_link duration, sim_objects
        end
      end

      def actor_died(actor, reason)
        if reason
          warn "#{actor.inspect} has died because of a #{reason.class} #{reason.message}"
        end
      end

      def relaunch_time_unit dead_actor
        p "++++++++++++++"
        time_unit = TimeUnit.new dead_actor.time_unit
        time_unit.resume dead_actor.started, dead_actor.units_since_start
        Celluloid::Actor[:time_unit] = time_unit
      end

      def relaunch_sim_loop dead_actor
        sim_loop = SimLoop.new_link dead_actor.duration, dead_actor.objects
        sim_loop.start if dead_actor.start_time
        Celluloid::Actor[:sim_loop] = sim_loop
      end

    end

  end
end
