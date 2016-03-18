module Sim
  # the player actor is linked with its connection
  # if one of the two crashes the other crashes as well
  class Player
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :id
    attr_accessor :connection

    def initialize id
      info "player init with #{id}"
      @id = id
      @message_handlers = Net::MessageHandler::Base.create_handlers(self)
    end

    def shutdown
      level = Celluloid::Actor[:level]
      level.async.remove_player @id
      debug "player[#{@id}] shutdown"
    end

    def receive message
      info "player[#{id}] received message #{message}"
      if answer = dispatch(message)
        send_message scope: message[:scope], action: message[:action], answer: answer
      end
    end

    def send_message message
      connection.send_message message
    end

  private

    def dispatch message
      if handler = handler(message[:scope])
        handler.dispatch(message)
      else
        raise ArgumentError, "no message handler found for scope #{message[:scope]} and player #{id}"
      end
    end

    def handler scope
      @message_handlers[scope.to_sym]
    end

  end

end
