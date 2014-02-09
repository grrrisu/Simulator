module Sim

  class Level
    include Celluloid
    include Celluloid::Logger

    def self.attach
      level = new
      level.listen_to_parent_process
    end

    def build config_file
      config = Buildable.load_config(config_file)
      Sim::Queue::Master.setup $stderr
      Sim::Queue::Master.launch config
      create(config)
    end

    def listen_to_parent_process
      Celluloid.logger = ::Logger.new($stderr) # TODO log to a file
      @process = Popen::SubProcess.new
      @process.listen(self)
    end

    # dispatches a message either to a player or this level
    def dispatch message
      if message.key? :player
        if player = find_player(message[:player])
          player.process_message message
        else
          raise ArgumentError, "no player[#{message[:player]} found in this level"
        end
      else
        process_message message
      end
    end

    # process a message and returns an answer
    def process_message message
      case message[:action]
        when 'build'
          build message[:params][:config_file]
        when 'load'
          load
        when 'start'
          async.start
          true
        when 'stop'
          stop
          true
        when 'add_player'
          add_player(message[:params][:id])
        when 'remove_player'
          remove_player(message[:params][:id])
        else
          raise ArgumentError, "unknown message #{message}"
      end
    end

    def start
      Sim::Queue::Master.start
    end


    def stop
      Sim::Queue::Master.stop
      @process.stop if @process
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
