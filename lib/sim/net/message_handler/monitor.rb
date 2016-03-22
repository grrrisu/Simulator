module Sim
  module Net
    module MessageHandler

      class Monitor < Base

        def subscribe
          monitor.async.subscribe session.player_id
        end

        def unsubscribe
          monitor.async.unsubscribe session.player_id
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
