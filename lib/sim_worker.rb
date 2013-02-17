class SimWorker
  include Celluloid

  def get_lock object
    @object = object
    Celluloid::Actor[:semaphore].obtain(current_actor, :sim, @object.get_key)
  end

  def sim
    @object.sim
  end

  def finalize
    puts "worker #{object_id} stopped"
  end

end
