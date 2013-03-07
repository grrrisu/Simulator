module Sim
  module Popen

    class SubProcess

      def start(receiver)
        @receiver = receiver
        send_message('ready')
        @running = true
        log 'started'
        receive_message
      end

      def stop
        @running = false
      end

      def receive_message
        while @running
          line = $stdin.readline.chomp
          begin
            answer = @receiver.process_message line
            send_message answer
          rescue Exception => e
            log "ERROR: #{e.class} #{e.message}"
            log e.backtrace.join("\n")
            send_message "exception #{e.message} in subprocess"
          end
        end
      rescue EOFError
        log "parent closed connection"
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
