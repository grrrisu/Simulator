module Sim

  class Level

    def self.attach(socket_path)
      level = new
      level.listen_to_parent_process(socket_path)
    end

    def build config_file
      config = Buildable.load_config(config_file)
      Sim::Queue::Master.launch config
      create(config)
    end

    def listen_to_parent_process socket_path
      Sim::Queue::Master.setup $stderr # TODO log to a file

      @player_server = Net::PlayerServer.new(self, socket_path)

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
