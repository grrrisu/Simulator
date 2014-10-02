require "open3"
require "thread"

module Sim
  module Net

    class ParentConnection
      include Open3
      include MessageSerializer

      attr_reader :pid

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

      def launch_subprocess sim_library, level_class, socket_path
        @mutex = Mutex.new
        cmd = %W{bundle exec #{RUBY} -r #{sim_library} -e #{level_class}.attach('#{socket_path}')}
        self.output, self.input, wait_thr = popen2({"SIM_ENV" => Rails.env}, *cmd)
        @pid = wait_thr.pid
        # wait for sub process to be ready
        receive_message
      end

      def send_message message
        # synchronize the sending messages from parent
        # for puma
        @mutex.synchronize do
          send_data message
          receive_message
        end
      end

      def send_action action, params = {}
        message = {}
        message[:action] = action
        message[:params] = params if params.try(:any?)
        send_message message
      end

      def receive_message
        message = receive_data
        if message[:answer]
          message[:answer]
        elsif message[:exception]
          raise RemoteException, message[:exception]
        elsif message[:action]
          raise ArgumentError, "got action #{message[:action]} but this is only a receiver"
        else
          raise ArgumentError, "message has no key answer or exception #{message.inspect}"
        end
      end

      def close
        output.close_write
        input.close
      end

    end

  end
end
