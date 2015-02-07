module Sim
  module Queue

    class Master < Celluloid::SupervisionGroup

      def self.launch level, sim_objects = []
        # this queues will be restarted automaticaly if they crash
        supervise EventQueue,        as: :event_queue
        pool      FireWorker,        as: :fire_workers
        supervise EventBroadcaster,  as: :event_broadcaster, args: level
        supervise LoopsSupervisor,   as: :loops_supervisor, args: [level.config, sim_objects]
        run!
      end

      def self.start
        Celluloid::Actor[:time_unit].start
        Celluloid::Actor[:sim_loop].start
      end

      def self.stop
        Celluloid::Actor[:loops_supervisor].try(:stop)
        Celluloid::Actor[:sim_loop].try(:stop)
        Celluloid::Actor.delete(:sim_loop)
        Celluloid::Actor[:event_queue].try(:stop)
        Celluloid::Actor[:fire_workers].try(:terminate)
        Celluloid::Actor[:time_unit].try(:stop)
        Celluloid::Actor.delete(:time_unit)
        Celluloid::Actor[:event_broadcaster].try(:stop)
      end

    end

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
        $stderr.puts "Oh no! #{actor.inspect} has died because of a #{reason.class} #{reason.message}"
      end

      def restart_time_unit
      end

      def restart_sim_loop
      end

    end

  end
end
