class SimSystem
  include Celluloid
  trap_exit :show_errors

  def show_errors(actor,reason)
    puts "********** Sim System ************"
    p actor
    p reason
    puts "*********************************"
  end

  def initialize
    @locks = {0 => false, 1 => false, 2 => false}
    @sim_objects = []
    @snapshot = Snapshot.new_link
  end

  def request lock
    unless locked?(lock)
      lock(lock)
      yield
      true
    else
      false
    end
  end

  def add object
    @sim_objects << object
    object.warmup
    Actor[:queue] << object
  end
  alias << add

  def remove object
    @sim_objects << object
    Actor[:queue].remove object
  end

  def lock_available? lock
    @locks[lock] == false
  end

  # if lock is available locks it and return ture, otherwise false
  def request_lock lock
    puts "System locks #{@locks.inspect}"
    lock_available?(lock) ? self.lock(lock) : false
  end

  def lock lock
    @locks[lock] = true
    puts "thread #{Thread.current} system locks #{lock} #{@locks}"
    true
  end

  def unlock lock
    $stdout.puts "thread #{Thread.current} system unlocks #{lock}"
    @locks[lock] = false
  end

  def listen changes
    @snapshot.listen!(changes)
  end

  def terminate
    unless locks.values.all? {|lock| lock == false }
      # someone still needs the this system
      sleep 1
      terminate
    else
      @snapshot.terminate
      super
    end
  end

end
