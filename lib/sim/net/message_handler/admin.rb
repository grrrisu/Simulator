module Sim
  module Net
    module MessageHandler

      class Admin < Base

        def create
          Celluloid::Actor[:level].create
          true
        end

        def start
          Celluloid::Actor[:sim_master].start
          true
        end

        def stop
          Celluloid::Actor[:sim_master].stop
          true
        end

      end

    end
  end
end
