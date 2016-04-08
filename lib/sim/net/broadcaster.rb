module Sim
  module Net
    class Broadcaster
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :player_crashed

      def broadcast player_ids, message
        player_ids = Array(player_ids)
        info "broadcast #{message.inspect} to #{player_ids}"
        Session.find_players(player_ids).each do |session|
          session.async.send_message message
        end
      end
      alias broadcast_to_players broadcast

      def broadcast_to_sessions sessions_ids, message
        sessions_ids = Array(sessions_ids)
        info "broadcast #{message.inspect} to #{sessions_ids}"
        sessions_ids.each do |session_id|
          session = Session.find session_id
          session.async.send_message message
        end
      end

      def broadcast_to_all message
        info "*** braodcast to all"
        info Session.registry_keys
        Session.registry_keys do |key|
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
