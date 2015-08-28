module Sim
  module Net

    class PlayerProxy

      attr_reader :id, :sim_connection

      def initialize id, role
        @id   = id
        @role = role
      end

      def send_message action, params = {}
        @sim_connection.send_object player_id: id, action: action, params: params
      end

      def connect_to_players_server(socket_path)
        EM.connect_unix_domain(socket_path, Handler) do |handler|
          handler.player_proxy = self
          @sim_connection = handler
          # register to player server
          handler.send_object(player_id: id, role: @role)
        end
      end

      def message_received message
        # override in subclass
      end

      module Handler
        include EventMachine::Protocols::ObjectProtocol

        attr_accessor :player_proxy

        def serializer
          JSON
        end

        def receive_object message
          EM.next_tick { player_proxy.message_received(message.symbolize_keys!) }
        end

      end

    end

  end
end
