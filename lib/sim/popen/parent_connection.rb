require "open3"

module Sim
  module Popen

    class ParentConnection
      include Open3

      attr_reader :in_connection, :out_connection, :pid

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
      SUBPROCESS_FILE = File.expand_path('../sub_process.rb', __FILE__)

      def start
        cmd = %W{#{RUBY} -r #{SUBPROCESS_FILE} -e Sim::Popen::SubProcess.start}
        @in_connection, @out_connection, wait_thr = popen2(*cmd)
        @pid = wait_thr.pid
        # wait for sub process to be ready
        #sleep 1
        #receive_message
      end

      def send_message message
        puts 'parent send message'
        in_connection.write(message + "\n")
        receive_message
      end

      def receive_message
        puts 'parent wait for message'
        out_connection.gets("\n").split("\n").each do |line|
          puts "[parent]: #{line}"
        end
      end

      def close
        @in_connection.close
        @out_connection.close
      end

    end

  end
end


connection = Sim::Popen::ParentConnection.new
p connection.start
p '******'
p connection
p connection.send_message 'see all the stars'
p '******'
