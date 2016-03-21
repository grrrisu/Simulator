module Sim
  module Net
    module MessageHandler

      class Monitor

        def initialize config
        end

        def subscribe player_id
          monitor.async.subscribe player_id
        end

        def unsubscribe player_id
          monitor.async.unsubscribe player_id
        end

        def logs
          monitor.logs
        end

      private

        def monitor
          Celluloid::Actor[:monitor]
        end

      end

    end
  end
end
