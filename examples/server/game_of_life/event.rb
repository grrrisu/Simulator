module GameOfLife

  class Event < Sim::Queue::Event::SimEvent

    def fire
      sim
    end

    def to_s
      "<GameOfLife::Event x:#{object.x} y:#{object.y} alive:#{object.alive.inspect}>"
    end

    def sim
      if !object.alive && alive_neighbours == 3
        set_alive true
      elsif object.alive && (alive_neighbours < 2 || alive_neighbours > 3)
        set_alive false
      else
        broadcast
      end
    end

    def alive_neighbours
      @alive_neighbours ||= object.look_around.inject(0) do |sum, neighbour|
        sum += neighbour.alive ? 1 : 0
      end
    end

    def set_alive value
      object.alive = value
      broadcast
    end

    def broadcast
      if broadcaster = Celluloid::Actor[:broadcaster]
        message = {scope: 'game_of_life', action: 'sim', answer: {x: object.x, y: object.y, alive: object.alive}}
        broadcaster.broadcast_to_all message
      end
    end

  end

end
