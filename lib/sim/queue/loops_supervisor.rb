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
        Celluloid::Actor[:time_unit] = TimeUnit.new_link config[:time_unit]
         
        duration = config[:time_unit] * config[:sim_loop][:duration]
        Celluloid::Actor[:sim_loop]  = SimLoop.new_link duration, sim_objects
      end

      def actor_died(actor, reason)
        $stderr.puts "Oh no! #{actor.inspect} has died because of a #{reason.class} #{reason.message if reason}"
        $stderr.puts reason.backtrace.join("\n") if reason
      end

      def restart_time_unit
      end

      def restart_sim_loop
      end

    end

  end
end
