module Sim

  class Object
    include Buildable

    attr_reader :delay

    default_attr :sim_threshold, 0.25

    def initialize
      touch # just in order that @last_touched is not nil
    end

    def touch time = Time.now
      @last_touched = time
    end

    def update_simulation time = Time.now
      @delay =  (time - @last_touched) / TimeUnit.instance.time_unit
      if @delay >= sim_threshold
        touch(time)
        sim
      end
    end

    def calculate delay
      raise "implement in subclass"
    end

    def sim
      calculate_steps
      changed_area
    end

    def calculate_steps
      delay.floor.times do
        calculate(1.0)
      end
      calculate(delay % 1.0)
    end

    def changed_area
      nil # nothing changed
    end

    def create_event
      Queue::SimEvent.new(self)
    end

  end

end
