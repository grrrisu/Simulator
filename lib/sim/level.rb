module Sim

  class Level
    include Buildable
    include Celluloid
    include Celluloid::Logger


    def self.attach
      level = boot
      level.listen_to_parent_process
    end

    def self.boot
      raise ArgumentError, "no configuration file present" unless ARGV[0]
      config_file = ARGV[0]
      new(config_file)
    end

    def initialize config_file
      config = Level.load_config(config_file)
      build config
    end

    def build config
      Sim::TimeUnit.new config["time_unit"]
      @queue = Sim::Queue.new
    end

    def listen_to_parent_process
      Celluloid.logger = ::Logger.new($stderr) # TODO log to a file
      @process = Popen::SubProcess.new
      @process.start(self)
    end

    # process a message and returns an answer
    def process_message message
      case message
      when 'start'
        start!
        true
      when 'stop'
        stop
        true
      else
        raise ArgumentError, "unknown message #{message}"
      end
    end

    def start
      @queue.start
    end

    def stop
      @process.stop if @process
      @queue.stop
      Celluloid.shutdown
    end

  end

end
