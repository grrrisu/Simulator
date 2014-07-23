module Sim
  module Net

    class SubProcess
      include MessageSerializer

      def listen(receiver)
        @receiver = receiver
        self.input, self.output = $stdin, $stdout
        send_message answer: 'ready'
        @running = true
        log 'started'
        listen_for_messages
      end

      def stop
        @running = false
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
        @running = false
        @receiver.stop_level
      rescue Exception => e
        log "ERROR: #{e.class} #{e.message}"
        log e.backtrace.join("\n")
        send_message exception: "#{e.class}: #{e.message}"
      end

      def send_message message
        log "send #{message}"
        send_data message
      end

      def log message
        $stderr.puts "[subprocess] #{message}"
      end

    end

  end
end