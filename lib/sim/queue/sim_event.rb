module Sim
  module Queue

    class SimEvent < Event

      attr_reader :object

      def initialize object
        @object = object or raise ArgumentError, "sim object must be set"
        @done = false
      end

      def to_s
        "<SimEvent obeject=#{object.class} x: #{object.field.x} y: #{object.field.y}>"
      end

      def notify area
        event_broadcaster.async.notify(area)
      end

      def fire
        area = object.sim
        notify(area)
      end

    end

  end
end
