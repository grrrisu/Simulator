module GameOfLife

  class Handler < Sim::Net::MessageHandler::Base

    def build config
      # TODO universe Actor
      Celluloid::Actor[:universe].universe   = World.new config[:size]
      # TODO setup Sim Loop config[:duration]
    end

    def start
      Celluloid::Actor[:sim_master].start
    end

    def stop
      Celluloid::Actor[:sim_master].stop
    end

  end

end
