module Sim
  module Queue

    class Master < Celluloid::SupervisionGroup

      def self.setup logfile
        Celluloid.logger = ::Logger.new(logfile)

        # this queues will be restarted automaticaly if they crash
        supervise EventQueue, as: :event_queue
        pool      FireWorker, as: :fire_workers
        run!
      end

      def self.launch config, sim_objects = []
        # this queues will NOT be restarted automaticaly if they crash
        Celluloid::Actor[:sim_loop]  = SimLoop.new config[:sim_loop][:duration], sim_objects
        Celluloid::Actor[:time_unit] = TimeUnit.new config[:time_unit]
      end

      def self.start
        Celluloid::Actor[:time_unit].start
        Celluloid::Actor[:event_queue].start
        Celluloid::Actor[:sim_loop].start
      end

      def self.stop
        Celluloid::Actor[:sim_loop].try(:stop)
        Celluloid::Actor[:event_queue].try(:stop)
        Celluloid::Actor[:time_unit].try(:stop)
      end

    end

  end
end
