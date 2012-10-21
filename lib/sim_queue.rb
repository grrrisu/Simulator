class SimQueue
  include Celluloid
  attr_reader :sim_objects, :stopped, :snapshot
  trap_exit :show_errors

  def show_errors(actor,reason)
    puts "********** Sim Queue ************"
    p actor
    p reason
    puts "*********************************"
  end

  def initialize
    @workers = SimWorker.pool(size: 5)
    @queue1, @queue2 = [], []
    @sim_objects = []
    @stopped = false
    @loop_time = 40
  end

  def trigger
    return if @stopped
    duration = Time.now - @last_run
    next_run = @loop_time - duration
    if next_run >= 0.0
      puts "next run in #{next_run} sec...."
      after(next_run) do
        puts "simulation loop took #{Time.now - @last_run}"
        run_workers
      end
    else
      raise Exception, "loop took too long"
    end
  end

  def current_queue
    @queue1
  end

  def stop
    @stopped = true
    @workers.finalize
  end

  def add(object)
    current_queue << object
  end
  alias << add

  def remove(object)
    current_queue.delete object
  end

  def start
    warmup
    run_workers
  end

  def warmup
    @queue1.each do |sim_object|
      sim_object.warmup
    end
  end

  def run_workers
    @last_run = Time.now
    p @queue1.map(&:sim_lock)
    timeout = @loop_time / (@queue1.size)
    while @queue1.any? && !@stopped
      puts "#{Thread.current} queue size #{@queue1.size}"
      object  = @queue1.pop
      if object.lock do
          begin
            @workers.future(:sim, object) # if so we need a an object in the queue that measures the loop time and adjusts the timer
          ensure
            @queue2 << object
          end
        end
      else
        puts "object locked #{object.sim_lock} retry later"
        sleep timeout
        position = (@workers.size + 1) > @queue1.size ? -1 : -(@workers.size + 1)
        @queue1.insert(position, object)
        p @queue1.map(&:sim_lock)
      end
    end
    @queue1, @queue2 = @queue2, @queue1
    @workers.trigger_queue Actor.current
    puts "run workers loop took #{Time.now - @last_run}"
  end

end
