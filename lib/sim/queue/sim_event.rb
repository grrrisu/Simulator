module Sim
  module Queue

    class SimEvent < Event

      attr_reader :object

      def initialize object
        @object = object or raise ArgumentError, "sim object must be set"
        @done = false
      end

      def to_s
        "<#{self.class} object=#{object.class} x: #{object.field.x} y: #{object.field.y}>"
      end

      def notify area
        if area
          event_broadcaster.async.notify(area)
        end
      end

      def fire
        changed_area = object.update_simulation
        notify(changed_area)
      end

      def owner_alive?
        @object.alive?
      end

    end

  end
end
