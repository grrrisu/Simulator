module GameOfLife

  class Handler < Sim::Net::MessageHandler::Base

    def build duration, size
      Celluloid::Actor[:sim_master].setup_sim_loop duration: duration, event_class: GameOfLife::Event
      world = create_world size
      world.to_json
    end

    def start
      Celluloid::Actor[:sim_master].start
    end

    def stop
      Celluloid::Actor[:sim_master].stop
    end

  private

    def create_world size
      world = World.new size
      world.create
      Celluloid::Actor[:universe].universe = world
      world
    end

  end

end
