module Sim
  module Queue
    class PlayerEvent

      attr_reader :player_id, :function

      def initialize player_id = nil, &block
        raise ArgumentError, "no block to fire" unless block_given?
        @player_id = player_id
        @function  = block
      end

      def fire
        @function.call(player_id)
      end

      def to_s
        "<Event player_id: #{player_id}>"
      end

    end

  end
end
