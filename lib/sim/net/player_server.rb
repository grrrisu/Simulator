module Sim
  module Net
    class PlayerServer
      include Celluloid::IO
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :player_connection_closed

      def initialize(file, start: false)
        @file = file
        @server = UNIXServer.new(file)
        boot if start
      rescue Errno::EADDRINUSE
        error "\e[0;31maddress in use\e[0m"
        raise
      end

      def boot
        info "player server listening ..."
        async.run
      end

      def run
        begin
          handle_connection @server.accept
        end until @server.closed?
      end

      def handle_connection(socket)
        info "client connected"
        connection = PlayerConnection.new_link(socket)
        connection.async.listen
      end

      def shutdown
        info "shutting down player server ..."
        @server.close if @server
        FileUtils.rm @file, force: true
      end

      def player_connection_closed(actor, reason)
        if reason
          warn "player connection #{actor.inspect} has died because of a #{reason.class}: #{reason.message}"
        end
      end

    end
  end
end
