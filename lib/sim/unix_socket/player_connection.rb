module Sim
  module UnixSocket

    class PlayerConnection
      include Popen::MessageSerializer

      def initialize player, socket
        self.input, self.output = socket, socket
        @player, player.connection = player, self
        @player.register(receive_data)
      end

      def listen
      end

    end

  end
end
