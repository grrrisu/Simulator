class SimWorker
  include Celluloid
  trap_exit :show_errors

  def show_errors(actor,reason)
    puts "********** Sim Worker ************"
    p actor
    p reason
    puts "*********************************"
  end

  def sim(object)
    $stdout.puts "worker #{Thread.current} started simulating object #{self}"
    object.sim
    $stdout.puts "worker #{Thread.current} ended simulating object #{self}"
  end

  def trigger_queue queue
    queue.trigger
  end

end
