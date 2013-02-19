module Sim

  class Guard
    include Celluloid

    def initialize
      @locks = {}
    end

    def to_key *args
      args.first
    end

    def obtain requester, method, *args
      lock = @locks[to_key(args)]
      unless lock
        @locks[to_key(args)] = requester.future.send(method)
      else
        lock.value # wait for requester to finish
        @locks[to_key(args)] = nil
        obtain requester, method, *args # retry
      end
    end

  end

end
