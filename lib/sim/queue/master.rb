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

  end
end
