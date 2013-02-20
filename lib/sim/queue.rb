module Sim

  class Queue
    include Celluloid

    attr_accessor :objects

    trap_exit :pool_died

    def initialize
      @pool = Sim::Worker.pool_link
      @objects = []
      @enumerator = @objects.each
    end

    def size
      @objects.size
    end

    def add object
      object.touch
      @objects << object
    end
    alias << add

    def start
      @running = true
      @objects.each {|obj| obj.touch}
      self.next!
    end

    def stop
      @running = false
      wait_for_busy_workers
    end

    def wait_for_busy_workers
      unless @pool.idle_size == @pool.size
        sleep 1
        wait_for_busy_workers
      end
    end

    def pool_died actor, reason
      puts "queue pool died #{actor} #{reason} #{current_actor.mailbox}"
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
            after(1) {self.next!}
          end
        else
          after(1) {self.next!}
        end
      end
    end

    def finalize
      puts "pool stopped #{@pool.busy_size}"
    end

  end

end
