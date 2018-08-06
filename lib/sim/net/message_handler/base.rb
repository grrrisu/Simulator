module Sim
  module Net
    module MessageHandler

      class Base

        attr_reader :session

        def initialize session
          @session = session
        end

        def process message
          send message[:action], *Array(message[:args])
        end

        def queue event
          Celluloid::Actor[:event_queue].async.add event
        end

        def broadcast player_ids, result
          broadcaster = Celluloid::Actor[:broadcaster]
          broadcaster.async.broadcast player_ids, result
        end

        def queue_player_event &block
          queue Queue::PlayerEvent.new(session.player_id, &block)
        end

      end

    end
  end
end
