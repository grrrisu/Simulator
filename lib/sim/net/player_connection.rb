module Sim
  module Net
    # the player actor is linked with its connection
    # if one of the two crashes the other crashes as well
    class PlayerConnection
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      attr_reader :socket

      def initialize socket
        @socket = socket
      end

      def listen
        begin
          data = socket.read
          receive data unless data.empty?
        end until data.empty? && socket.eof?
        info "client disconnected"
        @session.terminate if @session
        terminate
      end

      def receive data
        message = JSON.parse(data, symbolize_names: true)
        info "received message #{message}"
        session = get_session message[:player_id]
        session.receive(message)
      rescue StandardError => e
        message = {exception: e.class.name, message: e.message, data: data}
        socket.print message.to_json
        raise
      end

      def send_message(message)
        info "send message #{message}"
        socket.print message.to_json
      end

      def shutdown
        socket.close if socket
        info "socket closed"
      end

      private

      def get_session player_id
        raise ArgumentError, "player_id is required" unless player_id
        return @session if @session
        @session = Session.new_link(player_id)
        @session.connection = self
        @session
      end

    end
  end
end
