module Sim

  # access point to the universe
  class Universe
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_accessor :universe

    def shutdown
      debug "shutdown universe"
    end

  end

end
