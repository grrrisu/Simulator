module Sim

  class Object
    #include Buildable

    attr_reader :delay

    default_attr :sim_threshold, 0.25

    def initialize
      @alive = true
      @last_touched = 0.0
    end

    def touch time_unit
      @last_touched = time_unit
    end

    def update_simulation time_units
      @delay =  @last_touched - (time_units || now)
      if @delay >= sim_threshold
        touch now
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

    # TODO move to event
    def changed_area
      nil # nothing changed
    end

    # TODO move to sim_loop
    def create_event
      Queue::SimEvent.new(self)
    end

    def now
      Celluloid::Actor[:time_unit].time_elapsed
    end

  end

end
