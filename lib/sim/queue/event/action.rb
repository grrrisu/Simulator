module Sim
  module Queue
    module Event

      class Action < Base

        attr_reader :player_id

        def initialize player_id, object_id: nil, method: nil, args: []
          super object_id, method, args
          @player_id = player_id
        end

      end

    end
  end
end
