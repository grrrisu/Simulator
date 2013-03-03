module Sim

  class TimeUnit
    include Celluloid

    attr_reader :time_unit

    def self.instance
      Celluloid::Actor[:time_unit]
    end

    def initialize time_unit
      @time_unit = time_unit # secs representing 1 time unit
      Celluloid::Actor[:time_unit] = current_actor
    end

    def start
      now = Time.now
      @started, @time_last_change = now, now
      @units_since_start = 0
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

  end

end
