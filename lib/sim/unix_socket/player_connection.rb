module Sim
  module UnixSocket

    class PlayerConnection
      include Popen::MessageSerializer

      def initialize player, socket
        self.input, self.output = socket, socket
        @player, player.connection = player, self
        @player.register(receive_data)
        Reader.new(self).async.listen
        Writer.new(self).async.send_time
      end

      class Reader
        include Celluloid
        include Celluloid::Logger

        def initialize connection
          @connection = connection
        end

        def listen
          loop do
            data = @connection.receive_data
            $stderr.puts "**** player received #{data}"
          end
        end

      end

      class Writer
        include Celluloid
        include Celluloid::Logger

        def initialize connection
          @connection = connection
        end

        def send_time
          every(2) { @connection.send_data time: "Now it's #{Time.now.iso8601}" }
        end
      end

    end

  end
end
