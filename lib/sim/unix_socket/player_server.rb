module Sim
  module UnixSocket
    # accpets a connection for each player
    # does async communication
    class PlayerServer
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
        PlayerServer.new(level, socket_path)
      end

      def shutdown
        @listener.close if @listener
        FileUtils.rm @socket_path if @socket_path && File.exists?(@socket_path)
      end

      def run
        $stderr.puts "*** Player server ready to accept clients"
        loop { async.handle_connection(@listener.accept) }
      end

      def handle_connection(socket)
        player = @level.build_player(@level)
        PlayerConnection.new(player, socket)
      rescue Exception => e
        $stderr.puts "\e[0;31mconnection for player #{player.try(:id)} crashed!: \n #{e.message}"
        $stderr.puts e.backtrace.join("\n")
        $stderr.puts "\e[0m"
      end

    end
  end
end
