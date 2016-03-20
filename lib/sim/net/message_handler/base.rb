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

      end

    end
  end
end
