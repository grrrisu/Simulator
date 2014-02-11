module Sim

  class Level

    def self.attach
      level = new
      level.listen_to_parent_process
    end

    def build config_file
      config = Buildable.load_config(config_file)
      Sim::Queue::Master.launch config
      create(config)
    end

    def listen_to_parent_process
      Sim::Queue::Master.setup $stderr # TODO log to a file
      @dispatcher = Popen::MessageDispatcher.new self
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

    def add_player id
      # player_supervisors_as << Sim::Player.supervise_as "player_#{id}"
      raise "implement in subclass"
    end

    def remove_player id
      raise "implement in subclass"
    end

    def find_player id
      Celluloid::Actor["player_#{id}"]
    end

  end

end
