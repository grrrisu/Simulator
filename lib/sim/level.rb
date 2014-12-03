require 'yaml'

module Sim

  class Level
    include Singleton

    SIM_ENV = ENV['SIM_ENV'] unless defined? SIM_ENV

    attr_accessor :config, :players

    def self.attach config_file
      level = instance
      level.load_config(config_file)
      level.setup
    end

    def initialize
      @players = {}   # maps player_id to player obj
    end

    def setup
      setup_logger
      setup_queue
      setup_server
      setup_dispatcher
    end

    def load_config config_file
      @config = YAML.load(File.open(config_file)).deep_symbolize_keys
      @config = @config[SIM_ENV.to_sym]
    end

    def setup_logger
      logfile = File.open(File.expand_path(config[:log_file], config[:root_path]), 'a')
      logfile.sync = true
      #logfile = $stderr
      Celluloid.logger = ::Logger.new(logfile)
      Celluloid.logger.level = Logger::SEV_LABEL.index(config[:log_level])
    end

    def setup_queue
      Sim::Queue::Master.setup self
    end

    def setup_server
      socket_path = File.expand_path(config[:socket_file], config[:root_path])
      @player_server = Net::PlayerServer.new(self, socket_path)
    end

    def setup_dispatcher
      @dispatcher = Net::MessageDispatcher.new self
      @dispatcher.listen
    end

    def build config_file
      config = Buildable.load_config(config_file)
      Sim::Queue::Master.launch config
      create(config)
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

    def as_json
      {
        players: players.size,
        time_unit: Celluloid::Actor[:time_unit].try(:as_json),
        sim_loop: Celluloid::Actor[:sim_loop].try(:as_json),
        event_queue: Celluloid::Actor[:event_queue].try(:as_json)
      }
    end

    def objects_count
      Celluloid::Actor[:sim_loop].try(:objects_count)
    end

  end

end
