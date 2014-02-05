module Sim
  module Queue

    class EventQueue
      include Celluloid
      include Celluloid::Logger

      def initialize
        @do_it = true
      end

      def fire object
        if @do_it
          info "FIRE #{object}!"
          @do_it = false
        else
          raise "*** CRASH #{object} ***"
        end
      end

    end

  end
end
