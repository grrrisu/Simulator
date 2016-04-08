module Sim
  module Net
    class Broadcaster
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :player_crashed

      def broadcast_to_players player_ids, message
        player_ids = Array(player_ids)
        debug "broadcast #{message.inspect} to #{player_ids}"
        Session.find_players(player_ids).each do |session|
          session.async.send_message message
        end
      end
      alias broadcast broadcast_to_players

      def broadcast_to_sessions sessions_ids, message
        sessions_ids = Array(sessions_ids)
        debug "broadcast #{message.inspect} to #{sessions_ids}"
        sessions_ids.each do |session_id|
          session = Session.find session_id
          session.async.send_message message
        end
      end

      def broadcast_to_all message
        debug "broadcast to all #{Session.registry_keys}"
        Session.registry_keys.each do |key|
          Actor[key].async.send_message message
        end
      end

      def player_crashed actor, reason
        info "actor #{actor.inspect} dies of #{reason}:#{reason.message}"
      end

      def shutdown
        debug "shutdown broadcaster"
      end

    end
  end
end
