module Sim
  module Net

    class Session
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      attr_reader :session_id, :player_id
      attr_accessor :connection

      def self.find_players player_ids
        registry_keys.inject([]) do |sessions, key|
          if player_ids.include? Actor[key].player_id
            sessions << Actor[key]
          end
          sessions
        end
      end

      def self.find_player player_id
        registry_keys.each do |key|
          return Actor[key] if player_id == Actor[key].player_id
        end
      end

      def self.session_size
        registry_keys.size
      end

      def self.registry_keys
        Actor.registered.find_all do |key|
          key.to_s.start_with?('session_')
        end
      end

      def self.role name, &block
        @role_definitions ||= {}
        @role_definitions[name.to_sym] = block
      end

      def self.create_roles player_id
        @role_definitions.map do |name, callback|
          name if callback.call(player_id)
        end
      end

      def initialize player_id
        @player_id  = player_id
        @session_id = object_id
        Actor["session_#{session_id}"] = Actor.current
        @roles = Session.create_roles player_id
      end

      def receive message
        if authorized?(message)
          Actor[:message_dispatcher].async.dispatch(message, Actor.current)
        else
          raise "player #{player_id} is not authorized for #{message[:scope]}"
        end
      end

      def authorized?(message)
        @roles.include?(message[:scope].to_sym)
      end

      def send_message message
        connection.send_message message
      end

      def shutdown
        debug "shutdown session #{session_id} for player #{player_id}"
        Actor.delete "session_#{session_id}"
      end

    end
  end
end
