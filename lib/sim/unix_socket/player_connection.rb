module Sim
  module UnixSocket

    class PlayerConnection
      include Popen::MessageSerializer

      attr_reader :player

      def initialize socket
        self.input, self.output = socket, socket
      end

      def register level
        data                = receive_data
        @player             = level.add_player(data)
        @player.connection  = self

        send_data(player_id: @player.id, registered: true)
        Reader.new(self).async.listen
        @writer = Writer.new(self)
        #@writer.send_time
      end

      def forward_message data
        $stderr.puts "*** forward_message #{data}"
        check_permission!(data)
        action = data.delete(:action)
        if action && @player.respond_to?(action)
          answer = @player.send action, *data[:params].values
          send_message(action, answer)
        else
          raise ArgumentError, "player does not know how to handle action[#{action}]: #{data}"
        end
      end

      def send_message action, message
        @writer.async.send_message(action, message)
      end

      def check_permission!(data)
        # TODO check if player is allowed to execute this action
        unless data[:player_id] == @player.id
          raise ArgumentError, "message #{action} for player #{data[:player_id]} was sent to player[#{@player.id}]"
        end
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
            @connection.forward_message(data)
          end
        end

      end

      class Writer
        include Celluloid
        include Celluloid::Logger

        def initialize connection
          @connection = connection
        end

        def send_message action, message
          @connection.send_data action: action, answer: message
        end

        def send_time
          every(2) { @connection.send_data time: "Now it's #{Time.now.iso8601}" }
        end
      end

    end

  end
end
