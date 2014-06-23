module Sim
  module Popen

    class MessageDispatcher
      #include Celluloid
      #include Celluloid::Logger

      def initialize level
        @level = level
        @process = SubProcess.new
      end

      def listen
        @process.listen(self)
      end

      # dispatches a message either to a player or this level
      def dispatch message
        if message.key? :player
          if player = @level.find_player(message[:player])
            forward_message player, message
          else
            raise ArgumentError, "no player[#{message[:player]}] found in this level"
          end
        else
          process_message message
        end
      end

      def stop
        @process.stop if @process
      end

      def stop_level
        @level.stop
      end

      # process a message and returns an answer
      def process_message message
        case message[:action]
          when 'build'
            @level.build message[:params][:config_file]
            true
          when 'load'
            @level.load
          when 'start'
            #@level.async.start
            @level.start
            true
          when 'stop'
            @level.stop
            true
          when 'add_player'
            @level.add_player(message[:params][:id])
          when 'remove_player'
            @level.remove_player(message[:params][:id])
          else
            forward_message @level, message
        end
      end

      def forward_message receiver, message
        if receiver.respond_to? message[:action].to_sym
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
