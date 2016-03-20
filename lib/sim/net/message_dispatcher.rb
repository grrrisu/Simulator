module Sim
  module Net

    class MessageDispatcher
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      def self.register_handler handlers
        @handlers ||= {}
        handlers.each do |key, klass|
          @handlers[key] = klass
        end
      end

      def self.create_handler name, session
        if handler = @handlers[name.to_sym]
          handler.new(session)
        end
      end

      def dispatch message, session
        if answer = forward(message, session)
          session.send_message scope: message[:scope], action: message[:action], answer: answer
        end
      end

      def forward message, session
        if handler = MessageDispatcher.create_handler(message[:scope], session)
          handler.process(message)
        else
          raise ArgumentError, "no message handler found for scope #{message[:scope]} and player #{player_id}"
        end
      end

      def shutdown
        debug "shutdown message dispatcher"
      end

    end

  end
end
