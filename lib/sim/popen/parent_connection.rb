require "open3"

module Sim
  module Popen

    class ParentConnection
      include Open3

      attr_reader :pid

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

      def start sim_library, level_class, config_file
        cmd = %W{#{RUBY} -r #{sim_library} -e #{level_class}.attach #{config_file}}
        @in_connection, @out_connection, wait_thr = popen2(*cmd)
        @pid = wait_thr.pid
        # wait for sub process to be ready
        receive_message
      end

      def send_message message
        @in_connection.write(message + "\n")
        receive_message
      end

      def receive_message
        line = @out_connection.readline.chomp
        puts "[parent]: #{line}"
        line
      end

      def close
        @in_connection.close_write
        @out_connection.close
      end

    end

  end
end
