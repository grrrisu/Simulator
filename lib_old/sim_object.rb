class SimObject

  attr_reader :system

  def initialize system
    @system = system
    @system_lock = rand(3)
  end

  def warmup
    @last_touched = Time.now
  end

  def sim
    $stdout.puts "thread #{Thread.current} started simulating object #{self} after #{delay}"
    sleep 5
    $stdout.puts "thread #{Thread.current} ended simulating object #{self}"
    changes = "changes for #{object_id}"
    system.listen!(changes)
  ensure
    unlock
  end

  def delay time = Time.now
    delay =  time - @last_touched
    @last_touched = time
    delay
  end

  def lock
    if system.current_actor.request_lock(sim_lock)
      yield
      true
    else
      false
    end
  end

  def unlock
    system.current_actor.unlock(sim_lock)
  end

  def sim_lock
    @system_lock
  end

end
