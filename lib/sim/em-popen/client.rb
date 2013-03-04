require "eventmachine"

module Sim
  module EMPopen

    module ChildProcess

      def post_init
        puts 'client connected'
        send_data "hello from parent\n"
      end

      def receive_data(data)
        puts 'receiving data...'
        puts data.length, data.class
        data.split("\n").each do |line|
          puts "[parent] output: #{line}"
        end
      end

      def unbind
        puts "cient disconnected"
        EM.stop
      end

    end

    class Client

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

      SERVER_FILE = File.expand_path('../server.rb', __FILE__)

      def start
        EM.run do
          @subprocess = EM.popen("#{RUBY} -r#{SERVER_FILE} -e 'Sim::EMPopen::Server.start'", ChildProcess)
        end
        p @subprocess
      end

      def send_message message
        @subprocess.puts  message
      end

    end

  end
end

client = Sim::EMPopen::Client.new.start
