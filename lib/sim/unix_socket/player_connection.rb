module Sim
  module UnixSocket

    class PlayerConnection
      include Popen::MessageSerializer

      def initialize player, socket
        self.input, self.output = socket, socket
        @player, player.connection = player, self
        listen
      end

      def listen
        data = receive_data
        $stderr.puts "*** player data received #{data}"
        @player.register data
      end

    end

  end
end
