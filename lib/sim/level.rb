module Sim

  class Level
    include Singleton

    attr_accessor :root_path, :players

    def self.attach(root_path)
      level = instance
      level.listen_to_parent_process(root_path)
    end

    def initialize
      @players = {}       # maps player_id to player obj
    end

    def build config_file
      config = Buildable.load_config(config_file)
      Sim::Queue::Master.launch config
      create(config)
    end

    def log_file
      logfile = File.open(File.expand_path("log/level.log", root_path), 'a')
      logfile.sync = true
      logfile
      #$stderr
    end

    def listen_to_parent_process root_path
      @root_path = root_path
      Sim::Queue::Master.setup log_file, self

      @player_server = Net::PlayerServer.new(self, root_path)

      @dispatcher = Net::MessageDispatcher.new self
      @dispatcher.listen
    end

    def start
      Sim::Queue::Master.start
    end

    def stop
      @dispatcher.stop
      Sim::Queue::Master.stop
    end

    def create config
      raise "implement in subclass"
    end

    def load
      raise "implement in subclass"
    end

    def build_player data
      # Player.new(id, self)
      raise "implement in subclass"
    end

    def add_player player
      raise "implement in subclass"
    end

    def remove_player id
      raise "implement in subclass"
    end

    def find_player id
      #Celluloid::Actor["player_#{id}"]
    end

  end

end
