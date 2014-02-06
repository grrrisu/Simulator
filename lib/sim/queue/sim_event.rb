module Sim
  module Queue

    class SimEvent < Event

      def self.crash?
        if @crash
          @crash = false
          raise "*** CRASH ***"
        else
          @crash = true
        end
      end

      def needed_resources
        [] # none
      end

      def fire
        self.class.crash?
      end

    end

  end
end
