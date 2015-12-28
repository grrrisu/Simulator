module Sim
  module Net
    # accpets a connection for each player
    # does async communication
    class PlayerServer
      include Celluloid::IO
      include Celluloid::Logger
      finalizer :shutdown

      def initialize(level, socket_path)
        @listener = UNIXServer.new(socket_path)
        @socket_path = socket_path
        @level = level
        async.run
      rescue Errno::EADDRINUSE
        puts "\e[0;31maddress in use -> force restart!!!\e[0m"
        FileUtils.rm socket_path if File.exists? socket_path
        PlayerServer.new(level, socket_path)
      end

      def shutdown
        @listener.close if @listener
        FileUtils.rm @socket_path if @socket_path && File.exists?(@socket_path)
      end

      def run
        info "Player server ready to accept clients"
        loop { async.handle_connection(@listener.accept) }
      end

      def handle_connection(socket)
        connection = PlayerConnection.new(socket)
        connection.register(@level)
      rescue EOFError
        puts "*** parent process closed connection"
        socket.close
      rescue StandardError => e
        puts "\e[0;31mconnection for player #{connection.player.try(:id)} crashed!: \n #{e.message}"
        puts e.backtrace.join("\n") unless SIM_ENV == 'test'
        puts "\e[0m"
      end

    end
  end
end
