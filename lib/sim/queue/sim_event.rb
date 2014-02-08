module Sim
  module Queue

    class SimEvent < Event

      def needed_resources
        [] # none
      end

      def fire
        object.sim
      end

    end

  end
end
