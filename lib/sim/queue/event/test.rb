module Sim
  module Queue
    module Event

      class Test < Action

        def initialize player_id, text
          @player_id = player_id
          @text      = text
        end

        def fire
          broadcast player_id, scope: 'test', action: 'reverse', answer: reverse_text
        end

        def reverse_text
          @text.reverse
        end

      end

    end
  end
end
