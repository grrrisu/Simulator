module Sim
  module Net

    class MessageDispatcher

      def initialize level
        @level = level
        @process = SubProcess.new
      end

      def listen(socket_path)
        @process.listen(self, socket_path)
      end

      def stop
        @process.stop if @process
      end

      def stop_level
        @level.stop
      end

      # process a message and returns an answer
      def dispatch message
        case message[:action]
          when 'build'
            @level.build message[:params][:config_file]
            true
          when 'load'
            @level.load
          when 'start'
            @level.start
            true
          when 'stop'
            @level.stop
            true
          when 'remove_player'
            @level.remove_player(message[:params][:id])
          else
            forward_message @level, message
        end
      end

      def forward_message receiver, message
        if message[:action].present? && receiver.respond_to?(message[:action].to_sym)
          receiver.send message[:action].to_sym, *message[:params].try(:values) || []
          # TOOD Ruby 2
          # receiver.send message[:action].to_sym, **message[:params]
        else
          raise ArgumentError, "unknown message #{message} for #{receiver.class}"
          false
        end
      end

    end

  end
end
