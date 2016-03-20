module Sim
  module Net
    class Broadcaster
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown
      trap_exit :player_crashed

      def broadcast player_ids, message
        info "broadcast #{message.inspect} to #{player_ids}"
        Array(player_ids).each do |player_id|
          if session = Session.find player_id
            session.async.send_message message
          end
        end
      end

      def broadcast_to_all message
        # level.sessions.values.each do |session|
        #   session.send_message message
        # end
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
