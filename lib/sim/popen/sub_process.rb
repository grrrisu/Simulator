#require "eventmachine"

module Sim
  module Popen

    class SubProcess

      def self.start
        process = new
        process.send_message('ready')
        process.receive_message
      end

      def receive_message
        log 'started'
        2.times do
          line = $stdin.readline.chomp
          send_message "back again #{line.reverse}"
        end
        log "SubProcess ended!!!"
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
