module Example

  class WaitEvent < Sim::Queue::Event::Action

    def initialize player_id
      @player_id = player_id
    end

    def fire
      broadcast player_id, scope: 'test', action: 'reverse', answer: wait
    end

    def wait
      sleep 2
    end

  end

end
