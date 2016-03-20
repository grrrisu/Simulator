module Sim
  class Session
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :player_id
    attr_accessor :connection

    def self.find player_id
      Actor["session_#{player_id}"]
    end

    def initialize player_id
      @player_id = player_id
      @message_handlers = Net::MessageHandler::Base.create_handlers(self)
      Actor["session_#{player_id}"] = Actor.current
    end

    def receive message
      if answer = dispatch(message)
        send_message scope: message[:scope], action: message[:action], answer: answer
      end
    end

    def send_message message
      connection.send_message message
    end

    def shutdown
      Actor["session_#{player_id}"] = nil
    end

  private

    def create_handlers
      @message_handlers[:admin] = Net::MessageHandler::Admin.new(self)
    end

    def dispatch message
      if handler = handler(message[:scope])
        handler.dispatch(message)
      else
        raise ArgumentError, "no message handler found for scope #{message[:scope]} and player #{player_id}"
      end
    end

    def handler scope
      @message_handlers[scope.to_sym]
    end

  end

end
