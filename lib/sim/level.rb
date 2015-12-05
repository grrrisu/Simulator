require 'yaml'

module Sim

  class Level
    include Singleton

    attr_accessor :config, :level_config, :players

    def self.attach config_file
      level = instance
      level.load_config(config_file)
      level.setup
    end

    def initialize
      @players = {}   # maps player_id to player obj
    end

    def setup
      setup_process_name
      setup_logger
      setup_server
      setup_dispatcher
    end

    def load_config config_file
      @config = YAML.load(File.open(config_file)).deep_symbolize_keys
      @config = @config[SIM_ENV.to_sym]
    end

    def setup_process_name
      name = config[:process_name] || 'simulator'
      Process.setproctitle(name)
    end

    def setup_logger
      logfile = File.open(File.expand_path(config[:log_file], config[:root_path]), 'a')
      logfile.sync = true
      Celluloid.logger = ::Logger.new(logfile)
      Celluloid.logger.level = Logger::SEV_LABEL.index(config[:log_level])
    end

    def setup_server
      socket_path = File.expand_path(config[:player_socket_file], config[:root_path])
      @player_server = Net::PlayerServer.new(self, socket_path)
    end

    def setup_dispatcher
      @dispatcher = Net::MessageDispatcher.new self
      socket_path = File.expand_path(config[:level_socket_file], config[:root_path])
      @dispatcher.listen(socket_path)
    end

    def build config_file
      @level_config = Buildable.load_config(config_file)
      Sim::Queue::Master.launch self
      create(@level_config)
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
      objects = Celluloid::Actor[:sim_loop].try(:objects_count)
      time_elapsed = Celluloid::Actor[:time_unit].try(:zero_or_time_elapsed)
      objects.merge(time: time_elapsed.round)
    end

  end

end
