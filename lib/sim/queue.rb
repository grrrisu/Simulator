module Sim

  class Queue
    include Celluloid
    include Celluloid::Logger

    PRIORITY_HIGH = 0.2
    PRIORITY_MIDDLE = 0.5
    PRIORITY_LOW = 1.5

    # how many times the queue thread can be late in a row, before adjusing the time unit
    MAX_LATE_AGAIN = 3

    attr_accessor :objects

    trap_exit :pool_died

    def initialize priority = :high
      @pool = Sim::Worker.pool_link
      @objects = []
      @enumerator = @objects.each
      @priority = Queue.const_get('PRIORITY_'+priority.to_s.upcase)
    end

    def size
      @objects.size
    end

    def add object
      object.touch
      @objects << object
    end
    alias << add

    def remove object
      @objects.delete object
    end

    def start
      @running = true
      @objects.each {|obj| obj.touch}
      @last_run = Time.now
      self.next!
    end

    def stop
      @running = false
      wait_for_busy_workers
    end

    def wait_for_busy_workers
      unless @pool.idle_size == @pool.size
        info "wating for busy workers..."
        sleep max_time / (size * 2)
        wait_for_busy_workers
      end
    end

    def pool_died actor, reason
      warn "queue pool died #{actor} #{reason} #{current_actor.mailbox}"
    end

    def next
      if @running
        if @pool.idle_size > 0
          begin
            object = @enumerator.next
            @pool.process!(object)
            self.next!
          rescue StopIteration
            @enumerator.rewind
            after(wait_before_next_loop) do
              @last_run = Time.now
              self.next!
            end
          end
        else
          after(max_time / (size * 2)) {self.next!}
        end
      end
    end

    def max_time
      @max_time ||= Celluloid::Actor[:time_unit].time_unit * @priority
    end

    def wait_before_next_loop
      duration = Time.now - @last_run
      debug "queue took #{duration.to_f} sec for one loop"

      if duration <= max_time
        @late_again = 0
        max_time - duration
      else
        if @late_again < MAX_LATE_AGAIN
          @late_again += 1
          info "queue took too long [#{duration}], max time #{max_time} for #{@late_again} time! Give it try again!"
        else
          new_time_unit = duration / @priority
          info "queue took too long[#{duration}], max time #{max_time} -> setting time unit to #{new_time_unit}"
          Celluloid::Actor[:time_unit].time_unit = new_time_unit
          @max_time = nil
        end
        0
      end
    end

    def finalize
      debug "pool stopped #{@pool.busy_size}"
    end

  end

end
