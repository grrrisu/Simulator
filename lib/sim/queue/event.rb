module Sim
  module Queue

    class Event

      attr_reader :object

      def initialize object
        @object = object
        @done = false
      end

      def fire
        raise "implement in subclass"
      end

      def done!
        @done = true
      end

      def done?
        @done
      end

      def needed_resources
        [] # none
      end

    end

  end
end
