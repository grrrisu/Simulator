module Example

  class SimpleHandler < Sim::Net::MessageHandler::Base

    def reverse text
      queue SimpleEvent.new(player.id, text)
    end

    def direct_reverse text
      text.reverse
    end

  end

end
