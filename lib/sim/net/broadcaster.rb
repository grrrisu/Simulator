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

      def broadcast_to_all message
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
