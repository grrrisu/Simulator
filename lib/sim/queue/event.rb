module Sim
  module Queue

    class Event

      def to_s
        "<#{self.class}>"
      end

      def fire
        raise "implement in subclass"
      end

      def done!
        @done = true
      end

      def done?
        @done || false
      end

      def needed_resources
        [] # none
      end

      def event_broadcaster
        Celluloid::Actor[:event_broadcaster]
      end

    end

  end
end
