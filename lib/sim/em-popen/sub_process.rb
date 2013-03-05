require "eventmachine"

module Sim
  module EMPopen

    module SubProcessConnection

      def post_init
        $stderr.puts 'sub process init'
        #send_data "hello from parent\n"
      end

      def receive_data(data)
        #puts "receiving data... #{data.length} #{data.class}"
        data.split("\n").each do |line|
          $stderr.puts "[subprocess] output: #{line}"
          send_data line
        end
      end

      def unbind
        $stderr.puts "sub process disconnected"
        EM.stop
      end

    end

    class SubProcess

      def self.start
        #new
        EM.run do
          EM::attach($stdin, SubProcessConnection)
          puts 'server started'
        end
      end

    end

  end
end
