module Sim
  module Popen

    class SubProcess
      include MessageSerializer

      def start(receiver)
        @receiver = receiver
        self.input, self.output = $stdin, $stdout
        send_message('ready')
        @running = true
        log 'started'
        listen
      end

      def stop
        @running = false
      end

      def listen
        while @running
          receive_message
        end
      end

      def receive_message
        message = receive_data['message']
        answer = @receiver.process_message message
        send_message answer
      rescue EOFError
        log "parent closed connection"
        @receiver.stop
      rescue Exception => e
        log "ERROR: #{e.class} #{e.message}"
        log e.backtrace.join("\n")
        send_message "exception '#{e.message}' occured in subprocess"
      end

      def send_message message
        log "send #{message}"
        send_data message: message
      end

      def log message
        $stderr.puts "[subprocess] #{message}"
      end

      def p object
        $stderr.puts object.inspect
      end

    end

  end
end
