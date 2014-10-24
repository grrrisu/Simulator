module Sim
  module Queue

    class EventBroadcaster
      include Celluloid
      include Celluloid::Logger

      attr_accessor :level

      def initialize level
        @level = level
      end

      # notifies all players to renew their views
      def notify area, origin_player = nil
        level.players.values.each do |player|
          unless origin_player == player
            if player.overlap_current_view? area
              player.process_message(:update_view, area)
            end
          end
        end
      end

      def stop
        terminate
      end

    end

  end
end
