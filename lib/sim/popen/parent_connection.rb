require "open3"

module Sim
  module Popen

    class ParentConnection
      include Open3
      include MessageSerializer

      attr_reader :pid

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

      def start sim_library, level_class, config_file
        cmd = %W{#{RUBY} -r #{sim_library} -e #{level_class}.attach #{config_file}}
        self.output, self.input, wait_thr = popen2(*cmd)
        @pid = wait_thr.pid
        # wait for sub process to be ready
        receive_message
      end

      def send_message message
        send_data message: message
        receive_message
      end

      def receive_message
        message = receive_data['message']
        puts "[parent]: #{message}"
        message
      end

      def close
        output.close_write
        input.close
      end

    end

  end
end
