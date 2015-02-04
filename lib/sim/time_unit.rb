module Sim

  class TimeUnit
    include Celluloid
    include Celluloid::Logger

    attr_reader :time_unit

    def self.instance
      Celluloid::Actor[:time_unit]
    end

    def initialize time_unit
      @time_unit = time_unit # secs representing 1 time unit
      info "1 time unit = #{time_unit} secs"
    end

    def start
      now = Time.now
      @started, @time_last_change = now, now
      @units_since_start = 0
      info "time unit started at #{now}"
    end

    def stop
      terminate
    end

    def time_unit= value
      if @started
        @units_since_start = time_elapsed
        @time_last_change = Time.now
      end
      @time_unit = value.to_f
    end

    def time_elapsed
      @units_since_start + (Time.now - @time_last_change) / @time_unit
    end

    def zero_or_time_elapsed
      @started ? time_elapsed : 0.0
    end

    def as_json
      {
        time_unit: time_unit,
        time_elapsed: zero_or_time_elapsed.round(2),
        started: @started.try(:iso8601)
      }
    end

  end

end
