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
        @player.terminate if @player
        terminate
      end

      def receive data
        message = JSON.parse(data, symbolize_names: true)
        info "received message #{message}"
        player = get_player message[:player_id]
        player.receive(message)
      rescue StandardError => e
        message = {exception: e.class.name, message: e.message, data: data}
        socket.print message.to_json
        raise
      end

      def level
        Celluloid::Actor[:level]
      end

      def send_message(message)
        socket.print message.to_json
      end

      def shutdown
        socket.close if socket
        info "socket closed"
      end

      private

      def get_player player_id
        raise ArgumentError, "player_id is required" unless player_id
        return @player if @player
        @player = Player.new_link(player_id)
        @player.connection = self
        level.add_player @player
        @player
      end

    end
  end
end
