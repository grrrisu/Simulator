require "eventmachine"

module Sim
  module EMPopen

    module ParentProcessConnection

      def post_init
        puts 'client connected'
        send_data "hello from parent\n"
      end

      def receive_data(data)
        puts "receiving data... #{data.length} #{data.class}"
        data.split("\n").each do |line|
          puts "[parent] output: #{line}"
        end
      end

      def unbind
        puts "cient disconnected"
        EM.stop
      end

    end

    class ParentProcess

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
      SUBPROCESS_FILE = File.expand_path('../sub_process.rb', __FILE__)

      def self.start
        @connection = EM.popen("#{RUBY} -r#{SUBPROCESS_FILE} -e 'Sim::EMPopen::SubProcess.start'", ParentProcessConnection)
      end

    end

  end
end

t = Thread.new do
  EM.run do
    @connection = Sim::EMPopen::ParentProcess.start
    @connection.send_data 'after EM run'
  end
end

p @connection
sleep 1
p @connection
p '******'
p @connection.send_data 'see all the stars'
p '******'
t.join
