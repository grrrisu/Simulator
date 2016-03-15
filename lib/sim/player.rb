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
      create_handlers
    end

    def shutdown
      level = Celluloid::Actor[:level]
      level.async.remove_player @id
      debug "player[#{@id}] shutdown"
    end

    def receive message
      info "player[#{id}] received message #{message}"
      if answer = get_handler(message[:scope]).dispatch(message)
        send_message({scope: message[:scope], action: message[:action], answer: answer})
      end
    end

    def send_message message
      connection.send_message message
    end

  private

    def create_handlers
      @message_handlers = {}
      @message_handlers[:test] = Net::MessageHandler::Test.new(self)
    end

    def get_handler scope
      @message_handlers[scope.to_sym]
    end

  end

end
