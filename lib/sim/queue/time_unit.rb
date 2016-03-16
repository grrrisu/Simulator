module Sim
  module Queue
    class TimeUnit
      include Celluloid
      include Celluloid::Logger
      finalizer :shutdown

      attr_reader :time_unit, :units_since_start, :started

      def initialize seconds: 1, units_since_start: 0.0
        @time_unit         = seconds # secs representing 1 time unit
        @units_since_start = units_since_start
        info "1 time unit = #{time_unit} secs"
      end

      def start
        @started = Time.now
        info "time unit started at #{@started}"
      end
      alias resume start

      def stop
        # TODO save @units_since_start
      end

      def shutdown
        debug "shutdown time_unit"
      end

      def time_unit= value
        if started
          @units_since_start = time_elapsed
          @started = Time.now
        end
        @time_unit = value.to_f
      end

      def time_elapsed
        units_since_start + (Time.now - started) / time_unit
      end

      def zero_or_time_elapsed
        started ? time_elapsed : units_since_start
      end

      def as_json
        {
          time_unit: time_unit,
          time_elapsed: zero_or_time_elapsed.round(2),
          started: started&.iso8601
        }
      end

    end

  end
end
