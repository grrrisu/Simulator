module Sim

  class Level
    include Celluloid
    #include Celluloid::Logger
    include Buildable

    def self.boot
      raise ArgumentError, "no configuration file present" unless ARGV[0]
      config_file = ARGV[0]
      level = new(config_file)
    end

    def initialize config_file
      config = load_config(config_file)

      Sim::TimeUnit.new config["time_unit"]
      @queue = Sim::Queue.new

      create
      listen
    end

    def create
      raise ArgumentError, "overwrite in subclass"
      #Celluloid::Actor[:guard] = Sim::Guard.new
    end

    def listen
      @process = Popen::SubProcess.new(level)
      @process.start
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
      @process.stop
      @queue.stop
      Celluloid.shutdown
    end

  end

end
