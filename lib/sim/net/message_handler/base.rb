module Sim
  module Net
    module MessageHandler

      class Base

        attr_reader :session

        def self.register_handler handlers
          @handlers ||= {}
          handlers.each do |key, klass|
            @handlers[key] = klass
          end
        end

        def self.create_handlers(session)
          return {} unless @handlers
          @handlers.inject({}) do |handlers, item|
            handlers[item[0]] = item[1].new(session)
            handlers
          end
        end

        def initialize session
          @session = session
        end

        def dispatch message
          send message[:action], *Array(message[:args])
        end

        def queue event
          Celluloid::Actor[:event_queue].async.add event
        end

      end

    end
  end
end
