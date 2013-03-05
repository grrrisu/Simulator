require "eventmachine"

module Sim
  module Popen

    class SubProcess

      attr_accessor :running

      def self.start
        $sdterr.puts 'started'
        self.running = true
        while running
          $stdin.read.split("\n").each do |line|
            send_message "[parent] stdout: #{line}"
            self.running = false
          end
        end
        raise Exception, "SubProcess ended!!!"
      end

      def send_message message
        $stdout.puts message
      end

    end

  end
end
