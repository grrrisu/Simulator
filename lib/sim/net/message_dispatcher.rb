module Sim
  module Net

    class MessageDispatcher
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :handler_crashed

      def self.register_handler name, klass
        @handlers ||= {}
        @handlers[name] = klass
      end

      def self.create_handler name, session
        if handler = @handlers[name.to_sym]
          handler.new(session)
        end
      end

      def dispatch message, session
        if answer = forward(message, session)
          session.async.send_message scope: message[:scope], action: message[:action], answer: answer
        end
      end

      def forward message, session
        if handler = MessageDispatcher.create_handler(message[:scope], session)
          handler.process(message)
        else
          raise ArgumentError, "no message handler found for scope #{message[:scope]} and player #{player_id}"
        end
      end

      def handler_crashed actor, reason
        info "handler #{actor} crashed for reason #{reason}"
      end

      def shutdown
        debug "shutdown message dispatcher"
      end

    end

  end
end
