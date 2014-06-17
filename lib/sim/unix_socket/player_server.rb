module Sim
  module UnixSocket
    # accpets a connection for each player
    # does async communication
    class PlayerServer
      include Popen::MessageSerializer
      include Celluloid::IO
      finalizer :shutdown

      def initialize(level, socket_path)
        @listener = UNIXServer.new(socket_path)
        @socket_path = socket_path
        @level = level
        async.run
      rescue Errno::EADDRINUSE
        # FIME force restart
        FileUtils.rm socket_path if File.exists? socket_path
        PlayerServer.new(socket_path)
      end

      def shutdown
        @listener.close if @listener
        FileUtils.rm @socket_path if @socket_path && File.exists?(@socket_path)
      end

      def run
        $stderr.puts "*** Player server ready to accept clients"
        loop { async.handle_connection(@listener.accept) }
      end

      # FIXME input output for each(!) client
      def handle_connection(client)
        self.input, self.output = client, client

        data = receive_data
        $stderr.puts "*** player server: data received #{data}"

        if player = @level.find_player(data[:player_id])
          player.socket = client
          send_data(player_id: data[:player_id])
        else
          $stderr.puts "**** ERROR no player found with id #{data[:player_id]}"
        end
      end

    end
  end
end
