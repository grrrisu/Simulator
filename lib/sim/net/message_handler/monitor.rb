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

        def snapshot
          event_size  = Celluloid::Actor[:event_queue].future.events
          session_size = Session.session_size
          object_size = Celluloid::Actor[:sim_master].future.object_size
          time_unit   = Celluloid::Actor[:time_unit].zero_or_time_elapsed
          {
            session_size: session_size,
            event_size: event_size.value.size,
            object_size: object_size.value,
            time_unit: time_unit
          }
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
