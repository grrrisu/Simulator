module Sim
  module Queue

    class SimLoop
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      TIMEOUT = 5 #sec

      attr_reader :duration, :objects, :start_time

      finalizer :rescue_me

      def initialize duration, objects = []
        raise ArgumentError, "duration must be set" unless duration
        @duration = duration.to_f || 1.0
        @objects  = objects
        @counter  = 0
      end

      def add object
        #object.touch
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
        #@objects.each {|obj| obj.touch}
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
          event = next_object.create_event
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

      def event_queue
        Actor[:event_queue]
      end

    end

  end
end
