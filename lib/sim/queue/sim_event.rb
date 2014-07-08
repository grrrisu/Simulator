module Sim
  module Queue

    class SimEvent < Event

      attr_reader :object

      def initialize object
        @object = object or raise ArgumentError, "sim object must be set"
        @done = false
      end

      def to_s
        "<SimEvent>"
      end

      def fire
        object.sim
      end

    end

  end
end
