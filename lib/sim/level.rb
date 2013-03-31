module Sim

  class Level
    include Buildable
    include Celluloid
    include Celluloid::Logger

    trap_exit :actor_died
    finalizer :stop_subactors


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
      if message.key? 'player'
        player = find_player message['player']
        player.process_message message
      else
        case message['action']
        when 'start'
          async.start
          true
        when 'stop'
          stop
          true
        when 'create'
          create
        when 'load'
          load
        when 'add_player'
          add_player(message['params']['id'])
        when 'remove_player'
          remove_player(message['params']['id'])
        else
          raise ArgumentError, "unknown message #{message}"
        end
      end
    end

    def start
      @queue.start
    end


    def stop
      @process.stop if @process
      @queue.stop
    end

    def create
      raise "implement in subclass"
    end

    def load
      raise "implement in subclass"
    end

    def add_player id
      # player_supervisors_as << Sim::Player.supervise_as "player_#{id}"
      raise "implement in subclass"
    end

    def remove_player id
      raise "implement in subclass"
    end

    def actor_died actor, exception
      warn "[level] actor #{actor.inspect} died of reason #{exception}"
    end

    def find_player id
      Celluloid::Actor["player_#{id}"]
    end

    def stop_subactors
      @queue.terminate if @queue.alive?
      Celluloid::Actor[:time_unit].terminate if Celluloid::Actor[:time_unit].alive?
      debug "level stopped"
    end

  end

end
