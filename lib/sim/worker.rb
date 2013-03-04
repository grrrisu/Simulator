module Sim

  class Worker
    include Celluloid
    include Celluloid::Logger

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
      debug "worker #{object_id} stopped"
    end

  end

end
