module Sim
  module Queue

    class Master < Celluloid::SupervisionGroup

      def self.setup logfile
        Celluloid.logger = ::Logger.new(logfile)
        #Celluloid.logger = ::Logger.new("mylog.log")
      end

      def self.launch config, sim_objects = []
        # this queues will be restarted automaticaly if they crash
        supervise EventQueue, as: :event_queue  # declare first as sim_loop depends on it
        supervise SimLoop,    as: :sim_loop, args: [ config[:sim_loop][:duration], sim_objects ]
        pool      FireWorker, as: :fire_workers
        Celluloid::Actor[:time_unit] = TimeUnit.new config[:time_unit]
        run!
      end

      def self.start
        Celluloid::Actor[:time_unit].async.start
        Celluloid::Actor[:event_queue].async.start
        Celluloid::Actor[:sim_loop].async.start
      end

      def self.stop
        Celluloid::Actor[:sim_loop].stop
        Celluloid::Actor[:event_queue].stop
        Celluloid::Actor[:time_unit].stop
      end

    end

  end
end
