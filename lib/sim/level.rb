module Sim

  class Level
    include Buildable
    include Celluloid
    include Celluloid::Logger

    trap_exit :actor_died


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
      @queue = Sim::Queue.new_link
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
    end

    def actor_died actor, exception
      warn "[level] actor #{actor.inspect} died of reason #{exception}"
    end

    def finalize
      @queue.terminate if @queue.alive?
      Celluloid::Actor[:time_unit].terminate if Celluloid::Actor[:time_unit].alive?
      debug "level stopped"
    end

  end

end
