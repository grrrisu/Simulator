require 'celluloid'

class Guard
  include Celluloid

  trap_exit :pool_died

  def initialize
    @locks = {}
  end

  def to_key *args
    args.first
  end

  def obtain requester, method, *args
    logos = @locks[to_key(args)]
    unless logos
      puts "requester #{requester.object_id} obtained key #{to_key(args)}"
      @locks[to_key(args)] = requester.future.send(method)
    else
      puts "requester #{requester.object_id} waits for key #{to_key(args)}"
      logos.value # wait for requester to finish
      @locks[to_key(args)] = nil
      obtain requester, method, *args # retry
    end
  end

  def pool_died actor, reason
    puts "queue pool died #{actor} #{reason} #{current_actor.mailbox}"
  end

end

class SimObject

  attr_accessor :state, :name

  def initialize name
    self.name  = name
    self.state = 0
  end

  def get_key
    :a_key
  end

  def sim
    5.times do |i|
      self.state += 1
      puts "sim #{name} #{state}"
      sleep 1
    end
    puts 'done!'
    #raise Exception, "CRASH"
  end

end

class QueueWorker
  include Celluloid

  def get_lock object
    @object = object
    Celluloid::Actor[:guard].obtain(current_actor, :sim, @object.get_key)
  end

  def sim
    @object.sim
  end

  def finalize
    puts "worker #{object_id} stopped"
  end

end

class MyQueue
  include Celluloid

  attr_accessor :objects

  trap_exit :pool_died

  def initialize
    @pool = QueueWorker.pool_link
    @objects = []
    @enumerator = @objects.each
  end

  def add object
    @objects << object
    puts "added #{object.name}"
  end

  def start
    @stopped = false
    self.next!
  end

  def stop
    @stopped = true
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
    unless @stopped
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

Celluloid::Actor[:guard] = Guard.new
queue = MyQueue.new

queue.start

5.times do |i|
  queue.add!(SimObject.new("Sim#{i}"))
  sleep 1
end

sleep 6

queue.stop

queue.objects.each do |object|
  puts "the end: sim #{object.name} #{object.state}"
end

queue.terminate

