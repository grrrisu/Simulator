module Sim
  module Popen

    class SubProcess

      def start(receiver)
        @receiver = receiver
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
      rescue EOFError
        log "parent closed connection"
        @receiver.stop
      end

      def receive_message
        line = $stdin.readline.chomp
        begin
          answer = @receiver.process_message line
          send_message answer
        rescue Exception => e
          log "ERROR: #{e.class} #{e.message}"
          log e.backtrace.join("\n")
          send_message "exception '#{e.message}' occured in subprocess"
        end
      end

      def send_message message
        log "send #{message}"
        $stdout.puts message
        $stdout.flush
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
