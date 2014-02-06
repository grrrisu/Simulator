module Sim
  module Queue

    class FireWorker
      include Celluloid
      include Celluloid::Logger

      def fire event
        info "FIRE #{event.object}!"
        event.done!
      end

    end

  end
end
