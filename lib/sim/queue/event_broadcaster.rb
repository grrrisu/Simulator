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
      def notify(view_dimension)
        level.players.values.each do |player|
          if player.overlap_current_view? view_dimension
            player.process_message(:view, player.current_view_dimension)
          end
        end
      end

      def stop
        terminate
      end

    end

  end
end
