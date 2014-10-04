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
          within_dimension(player, view_dimension) do
            player.process_message(:view, view_dimension)
          end
        end
      end

      def within_dimension player, view_dimension
        other_dimension = player.current_view_dimension
        # if other_dimension[:x] <= view_dimension[:x] &&
        #    other_dimension[:y] <= view_dimension[:y]
             yield
        #end
      end

      def stop
        terminate
      end

    end

  end
end
