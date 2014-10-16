module Sim

  class Object

    attr_reader :delay

    def initialize
      # just in order that @last_touched is not nil
      @last_touched = Time.now
    end

    def touch time = Time.now
      @delay =  (time - @last_touched) / TimeUnit.instance.time_unit
      @last_touched = time
    end

    def calculate
      raise "implement in subclass"
    end

    def sim
      touch
      calculate
    end

    def create_event
      Queue::SimEvent.new(self)
    end

  end

end
