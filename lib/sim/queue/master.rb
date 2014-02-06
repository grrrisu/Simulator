module Sim
  module Queue

    class Master < Celluloid::SupervisionGroup

      def self.launch level
        # this queues will be restarted automaticaly if they crash
        supervise EventQueue, as: :event_queue  # declare first as sim_loop depends on it
        supervise SimLoop,    as: :sim_loop,    args: [ 15, [1,2,3,4,5] ]
        pool      FireWorker, as: :fire_workers
      end

      def self.start
        Celluloid::Actor[:event_queue].async.start
        Celluloid::Actor[:sim_loop].async.start
      end

      def self.stop
        Celluloid::Actor[:sim_loop].stop
        Celluloid::Actor[:event_queue].stop
      end

    end

  end
end
