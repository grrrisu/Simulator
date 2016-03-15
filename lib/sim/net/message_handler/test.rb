module Sim
  module Net
    module MessageHandler

      class Test < Base

        def reverse text
          queue Queue::Event::Test.new(player.id, text)
        end

        def direct_reverse text
          text.reverse
        end

      end

    end
  end
end
