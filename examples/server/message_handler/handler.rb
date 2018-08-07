module Example

  class Handler < Sim::Net::MessageHandler::Base

    def reverse text
      queue_player_event do |player_id|
        broadcast player_id, scope: 'example', action: 'reverse', answer: text.reverse
      end
    end

    def crash
      queue_player_event do |player_id|
        raise 'Oh Snap!'
      end
    end

    def wait
      queue_player_event do |player_id|
        sleep 2
      end
    end

  end

end
