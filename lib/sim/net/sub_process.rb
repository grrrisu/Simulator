module Sim
  module Net

    class SubProcess
      include MessageSerializer

      attr_reader :socket_path

      def listen(receiver, socket_path)
        @receiver = receiver
        @socket_path = socket_path

        start_server
        run
      end

      def start_server
        server = UNIXServer.new(@socket_path)
        socket = server.accept
        self.input, self.output = socket, socket
      end

      def run
        send_message answer: 'ready'
        @running = true
        log 'level is running'
        listen_for_messages
      end

      def stop
        @running = false
        FileUtils.rm socket_path if socket_path && File.exists?(socket_path)
      end

      def listen_for_messages
        while @running
          receive_message
        end
      end

      def receive_message
        message = receive_data
        if message[:answer]
          raise ArgumentError, "got answer #{message[:answer]} but this is only an executer"
        elsif message[:exception]
          raise RemoteException, message[:exception]
        elsif message[:action]
          answer = @receiver.dispatch message
          send_message answer: answer
        else
          raise ArgumentError, "message has no key action or exception #{message.inspect}"
        end
      rescue EOFError, Errno::EPIPE
        log "parent closed connection"
        stop
        @receiver.stop_level
      rescue Exception => e
        log "ERROR: #{e.class} #{e.message}"
        log e.backtrace.join("\n")
        send_message exception: "#{e.class}: #{e.message}"
      end

      def send_message message
        send_data message
      end

      def log message
        unless SIM_ENV == 'test'
          $stderr.puts "[subprocess] #{message}"
        end
      end

    end

  end
end
