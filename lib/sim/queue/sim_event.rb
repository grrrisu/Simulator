module Sim
  module Queue
    class SimEvent

      attr_reader :object

      # param object must implement a reader for the wrapped object
      # and provide a sim method
      def initialize object
        @object = object
      end

      def fire
        object.sim
      end

      def to_s
        "<SimEvent object: #{object}>"
      end

    end

  end
end
