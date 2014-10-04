module Sim
  module Queue

    class ActionEvent < Event

      attr_reader :player, :action, :params

      def initialize player, action, params
        @player = player
        @action = action
        @params = params # Hash
        @start  = Time.now
      end

      def to_s
        "<ActionEvent action=#{@action} player_id=#{@player.id} params=#{@params}>"
      end

      def notify_listners
        event_broadcaster.async.notify(player.current_view_dimension)
      end

      def fire
        answer = player.send(action, *params.values)
        $stderr.puts("*** event sending back answer after #{Time.now - @start}")
        player.connection.send_message(action, answer)
        notify_listners
      end

    end

  end
end
