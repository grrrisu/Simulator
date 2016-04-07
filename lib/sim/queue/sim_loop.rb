module Sim
  module Queue

    class SimLoop
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      TIMEOUT = 5 #sec

      attr_reader :duration, :objects, :start_time

      finalizer :rescue_me

      def initialize duration: 1.0 , objects: [], event_class: SimEvent
        raise ArgumentError, "duration must be set" unless duration
        @duration    = duration.to_f
        @objects     = objects
        @event_class = event_class
        @counter     = 0
      end

      def add object
        @objects << object
      end
      alias << add

      def remove object
        return unless @objects.include?(object)
        debug "remove #{object.inspect}"
        if @objects.index(object) < @counter
          @counter -= 1
        end
        @objects.delete object
      end

      def start
        @start_time = Time.now
        info "sim loop started..."
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

      def sim
        if @objects.any?
          event = create_event next_object
          event_queue.async.add event
          @timer = after(delay) { sim }
        else
          @timer = after(TIMEOUT) { sim }
        end
      end

      def shutdown
        debug "shutdown sim loop with duration #{duration}"
      end

      def as_json
        {
          duration: @duration,
          objects: @objects.size
        }
      end

      def objects_count
        @objects.inject({}) do |klasses, obj|
          klasses.tap do
            klasses[obj.class.to_s] ||= 0
            klasses[obj.class.to_s] += 1
          end
        end
      end

    private

      def create_event sim_object
        @event_class.new(sim_object)
      end

      def event_queue
        Actor[:event_queue]
      end

    end

  end
end
