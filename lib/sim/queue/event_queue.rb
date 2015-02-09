require 'set'

module Sim
  module Queue

    class EventQueue
      include Celluloid
      include Celluloid::Logger

      DELAY   = 0.1 #sec

      WAITING_TRESHOLD = 10

      def initialize
        @locks      = Set.new
        @waitings   = []
        @processing = []
      end

      def fire_workers
        Celluloid::Actor[:fire_workers]
      end

      def stop
        @timer.reset if @timer
        terminate
      end

      def needed_resources_free? event
        event.needed_resources.none? {|resource| @locks.include? resource }
      rescue NoMethodError
        raise unless event.owner_alive? # re-raise exception if error did not occur because owner is dead
        false
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
          if needed_resources_free?(event)
            lock_resources(event)
            @processing << event
            @waitings.delete(event)
            fire_workers.async.fire(event)
          end
        end
      end

      def run
        release_finished_events
        check_queue
        delegate_ready_events
        # if we have any blocked or running events, we run this again
        @timer = after(DELAY) { run } if @waitings.any? || @processing.any?
      end

      def check_queue
        if @waitings.size > WAITING_TRESHOLD
          warn "#{@waitings.size} in waiting queue, #{@processing.size} processing, #{@locks.size} locks"
        end
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

      def as_json
        {
          waitings: @waitings.size,
          processing: @processing.size,
          locks: @locks.size,
          workers: Celluloid::Actor[:fire_workers].size
        }
      end

    end

  end
end
