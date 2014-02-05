module Sim

  class Worker
    include Celluloid
    include Celluloid::Logger

    finalizer :debug_stop

    def process object
      @object = object
      guard = object.parent_guard
      guard.obtain(current_actor, :sim, @object.get_key)
    end

    def sim
      @object.touch
      @object.sim
    end

    def debug_stop
      debug "worker #{object_id} stopped"
    end

  end

end