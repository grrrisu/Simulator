module GameOfLife

  class Event < Sim::Queue::Event::SimEvent

    def fire
      sim
      broadcast
    end

    def sim

    end

    def broadcast
      if broadcaster = Celluloid::Actor[:broadcaster]
        message = {scope: 'game_of_life', action: 'sim', answer: {x: object.x, y: object.y, alive: object.alive}}
        broadcaster.broadcast_to_all message
      end
    end

  end

end
