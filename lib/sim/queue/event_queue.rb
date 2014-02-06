module Sim
  module Queue

    class EventQueue
      include Celluloid
      include Celluloid::Logger

      TIMEOUT = 1 # sec
      DELAY   = 0.1 #sec

      def initialize
        @locks      = []
        @waitings   = []
        @processing = []
        @pool       = FireWorker.pool
      end

      def start
        run
      end

      def stop
        @timer.reset
      end

      def needed_resources_free? event
        event.needed_resources.none? {|resource| @locks.include? resource }
      end

      def lock_resources event
        @locks + event.needed_resources
      end

      def unlock_resources event
        @locks - event.needed_resources
      end

      def release_finished_events
        @processing.find_all do |event|
          event.done?
        end.each do |event|
          unlock_resources(event)
          @processing.delete(event)
        end
      end

      def delegate_ready_events
        @waitings.find_all do |event|
          needed_resources_free?(event)
        end[0, @pool.idle_size].each do |event|
          lock_resources(event)
          @waitings.delete(event)
          @processing << event
          @pool.async.fire(event)
        end
      end

      def delay
        @processing.empty? ? TIMEOUT : DELAY
      end

      def run
        # release finished events
        release_finished_events
        # collect unblocked events
        delegate_ready_events
        # after delay restart again
        @timer = after(delay) { run }
      end

      def remove_event object
        @waitings.delete_if {|event| event.object == object }
      end

      def fire event
        @waitings << event
      end

    end

  end
end
