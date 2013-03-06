require "eventmachine"

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
          $stdin.gets("\n").split("\n").each do |line|
            log line
            send_message "back again #{line.reverse}"
          end
        end
        log "SubProcess ended!!!"
      end

      def send_message message
        log "send #{message}"
        $stdout.write(message + "\n")
      end

      def log message
        $stderr.puts "[subprocess] #{message}"
      end

    end

  end
end
