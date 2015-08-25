require "open3"
require "thread"

module Sim
  module Net

    class ParentConnection
      include MessageSerializer

      attr_reader :pid

      RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

      def initialize
        @mutex = Mutex.new
      end

      def launch_subprocess sim_library, level_class, config_file, env = 'development'
        cmd = "SIM_ENV=#{env} bundle exec #{RUBY} -r #{sim_library} -e '#{level_class}.attach(\"#{config_file}\")'"
        @pid = Process.spawn cmd

        socket_path = level_socket_path(config_file, env)
        wait_for_server(socket_path) do
          socket = UNIXSocket.new(socket_path)
          self.input, self.output = socket, socket
          receive_message
        end
      end

      def level_socket_path config_file, env
        config = YAML.load(File.open(config_file)).deep_symbolize_keys
        config = config[env.to_sym]
        File.expand_path(config[:level_socket_file], config[:root_path])
      end

      def wait_for_server socket_path
        until File.exists?(socket_path) do
          sleep 0.5
        end
        yield
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
        input.close if input
      end

    end

  end
end
