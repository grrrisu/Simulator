module Sim
  module UnixSocket

    class PlayerConnection
      include Popen::MessageSerializer

      def initialize level, socket
        self.input, self.output = socket, socket
        @level = level
        #@player, player.connection = player, self
        listen
      end

      def register player_id

      end

      def listen
        data = receive_data
        $stderr.puts "*** player server: data received #{data}"

        if player = @level.find_player(data[:player_id])
          player.connection = self
          send_data(player_id: data[:player_id])
        else
          $stderr.puts "**** ERROR no player found with id #{data[:player_id]}"
        end
      end

    end

  end
end
