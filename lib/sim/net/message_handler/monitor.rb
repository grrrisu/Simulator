module Sim
  module Net
    module MessageHandler

      class Monitor < Base

        def subscribe
          monitor.async.subscribe session.session_id
        end

        def unsubscribe
          monitor.async.unsubscribe session.session_id
        end

        def snapshot
          monitor.snapshot
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
