module GameOfLife

  class Handler < Sim::Net::MessageHandler::Base

    def build duration, size
      Celluloid::Actor[:universe].universe = World.new size
      Celluloid::Actor[:sim_master].setup_sim_loop duration: duration, event_class: GameOfLife::Event 
    end

    def start
      Celluloid::Actor[:sim_master].start
    end

    def stop
      Celluloid::Actor[:sim_master].stop
    end

  end

end
