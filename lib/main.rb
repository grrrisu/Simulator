require 'celluloid'

class SimObject

  attr_accessor :state, :name

  def initialize name
    self.name  = name
    self.state = 0
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

class Worker
  include Celluloid

  def sim object
    object.sim
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
    @pool = Worker.pool_link
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
    puts "pool died #{actor} #{reason} #{current_actor.mailbox}"
  end

  def next
    puts "next #{@pool.idle_size}"
    unless @stopped
      if @pool.idle_size > 0
        begin
          object = @enumerator.next
          @pool.sim!(object)
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


queue = MyQueue.new

queue.start

5.times do |i|
  queue.add!(SimObject.new("Sim#{i}"))
  sleep 1
end

sleep 8

queue.stop

queue.objects.each do |object|
  puts "the end: sim #{object.name} #{object.state}"
end

queue.terminate

