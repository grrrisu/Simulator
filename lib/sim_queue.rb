class SimQueue
  include Celluloid

  attr_accessor :objects

  trap_exit :pool_died

  def initialize
    @pool = SimWorker.pool_link
    @objects = []
    @enumerator = @objects.each
  end

  def size
    @objects.size
  end

  def add object
    @objects << object
    #puts "added #{object.name}"
  end
  alias << add

  def start
    @running = true
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
    puts "next #{@pool.idle_size}"
    if @running
      if @pool.idle_size > 0
        begin
          object = @enumerator.next
          @pool.get_lock!(object)
          self.next!
        rescue StopIteration
          @enumerator.rewind
          puts "all objects simulated!"
          after(1) {self.next!}
        end
      else
        after(1) {self.next!}
      end
    end
    puts " end"
  end

  def finalize
    puts "pool stopped #{@pool.busy_size}"
  end

end
