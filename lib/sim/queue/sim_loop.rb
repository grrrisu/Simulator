module Sim
  module Queue

    class SimLoop
      include Celluloid
      include Celluloid::Logger

      def initialize duration, objects = []
        @duration = duration.to_f || 1.0
        @objects  = objects
        @counter  = 0
      end

      def add object
        debug "add #{object} #{@objects}"
        @objects << object
      end
      alias << add

      def remove object
        debug "remove #{object} #{@objects}"
        if @objects.index(object) < @counter
          @counter -= 1
        end
        event_queue.remove_events(object)
        @objects.delete object
      end

      def event_queue
        Actor[:event_queue]
      end

      def start
        @start_time = Time.now
        sim
      end

      def stop
        @timer.reset if @timer
        terminate
      end

      def delay
        @duration / @objects.size
      end

      def stop_time
        stop_time = Time.now
        info "loop took #{stop_time - @start_time}"
        @start_time = stop_time
      end

      def next_object
        if @counter == @objects.size
          stop_time
          @counter = 0
        end
        object = @objects[@counter]
        @counter += 1
        object
      end

      def create_event object
        SimEvent.new(object)
      end

      def sim
        event = create_event(next_object)
        event_queue.async.fire(event)
        @timer = after(delay) { sim }
      end

    end

  end
end
