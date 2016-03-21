module Example

  class CrashEvent < Sim::Queue::Event::Action

    def initialize player_id
      @player_id = player_id
    end

    def fire
      raise 'Oh Snap!'
    end

  end

end
