module Sim

  class TimeUnit
    include Celluloid

    def initialize time_unit
      @time_unit = time_unit # secs representing 1 time unit
    end

    def start
      now = Time.now
      p now
      @started, @time_last_change = now, now
      @units_since_start = 0
      p 'end start'
    end

    def time_unit= value
      p "set time unit #{value}"
      if @started
        @units_since_start = time_elapsed
        now = Time.now
        p now
        @time_last_change = now
      end
      @time_unit = value.to_f
    end

    def time_elapsed
      p "time elpased"
      now = Time.now
      p now, @time_unit, now - @time_last_change
      @units_since_start + (now - @time_last_change) / @time_unit
    end

  end

end
