require "open3"

module Sim
  module Popen

    class ParentConnection
      include Open3

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
      SUBPROCESS_FILE = File.expand_path('../sub_process.rb', __FILE__)

      def start
        io = popen3(RUBY, '-r', SUBPROCESS_FILE, '-e', 'Sim::Popen::SubProcess.start') do |stdin, stdout, stderr|
          @in_connection = stdin
          @out_connection = stdout
          $stderr = stderr
        end
        puts "end popen3", io
      ensure
        $stderr.read.split("\n").each do |line|
          puts "[parent] stdout: #{line}"
        end
      end

      def send_message message
        @in_connection.write(message)
        @out_connection.read.split("\n").each do |line|
          puts "[parent] stdout: #{line}"
        end
      end

      def receive_message

      end

      def close
        @in_connection.close_write
      end

    end

  end
end


connection = Sim::Popen::ParentConnection.new.start
p '******'
p connection
p connection.send_message 'see all the stars'
p '******'
