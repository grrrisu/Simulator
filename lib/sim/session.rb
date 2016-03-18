module Sim
  # the player actor is linked with its connection
  # if one of the two crashes the other crashes as well
  class Session
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :player_id
    attr_accessor :connection

    def initialize player_id
      info "session init with #{player_id}"
      @player_id = player_id
      create_handlers
    end

    def shutdown
      level = Celluloid::Actor[:level]
      level.async.remove_session @player_id
      debug "player[#{@player_id}] shutdown"
    end

    def receive message
      info "player[#{@player_id}] received message #{message}"
      if answer = dispatch(message)
        send_message scope: message[:scope], action: message[:action], answer: answer
      end
    end

    def send_message message
      connection.send_message message
    end

  private

    def create_handlers
      @message_handlers = {}
      @message_handlers[:test]  = Net::MessageHandler::Test.new(self)
      @message_handlers[:admin] = Net::MessageHandler::Admin.new(self)
    end

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
