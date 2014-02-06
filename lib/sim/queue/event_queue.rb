require 'set'

module Sim
  module Queue

    class EventQueue
      include Celluloid
      include Celluloid::Logger

      DELAY   = 0.1 #sec

      def initialize
        @locks      = Set.new
        @waitings   = []
        @processing = []
      end

      def fire_workers
        Celluloid::Actor[:fire_workers]
      end

      def start
      end

      def stop
        @timer.reset if @timer
        terminate
      end

      def needed_resources_free? event
        event.needed_resources.none? {|resource| @locks.include? resource }
      end

      def lock_resources event
        @locks.merge event.needed_resources
      end

      def unlock_resources event
        @locks.subtract event.needed_resources
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
        events = @waitings.clone
        while events.any? && fire_workers.idle_size > 0
          event = events.pop
          needed_resources_free?(event)
          lock_resources(event)
          @processing << event
          @waitings.delete(event)
          fire_workers.async.fire(event)
        end
      end

      def run
        release_finished_events
        delegate_ready_events
        debug "waitings: #{@waitings.size} processing: #{@processing.size}"
        # if we have any blocked or running events, we run this again
        @timer = after(DELAY) { run } if @waitings.any? || @processing.any?
      end

      # removes all events belonging to the object
      def remove_events object
        @waitings.delete_if {|event| event.object == object }
      end

      def fire event
        @waitings << event
        @timer.reset if @timer
        run
      end

    end

  end
end
