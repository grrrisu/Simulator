module Sim

  class Worker
    include Celluloid

    def process object
      @object = object
      guard = object.parent_guard
      guard.obtain(current_actor, :sim, @object.get_key)
    end

    def sim
      @object.touch
      @object.sim
    end

    def finalize
      puts "worker #{object_id} stopped"
    end

  end

end
