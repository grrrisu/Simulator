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
      logos = @locks[to_key(args)]
      unless logos
        puts "requester #{requester.object_id} obtained key #{to_key(args)}"
        @locks[to_key(args)] = requester.future.send(method)
      else
        puts "requester #{requester.object_id} waits for key #{to_key(args)}"
        logos.value # wait for requester to finish
        @locks[to_key(args)] = nil
        obtain requester, method, *args # retry
      end
    end

  end

end
