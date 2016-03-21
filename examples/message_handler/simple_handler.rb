module Example

  class SimpleHandler < Sim::Net::MessageHandler::Base

    def reverse text
      queue SimpleEvent.new(session.player_id, text)
    end

    def crash
      queue CrashEvent.new(session.player_id)
    end

  end

end
