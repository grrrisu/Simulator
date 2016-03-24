module Example

  class Handler < Sim::Net::MessageHandler::Base

    def reverse text
      queue ReverseEvent.new(session.player_id, text)
    end

    def crash
      queue CrashEvent.new(session.player_id)
    end

    def wait
      queue WaitEvent.new(session.player_id)
    end

  end

end
