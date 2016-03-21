module Sim

  class Session
    include Celluloid
    include Celluloid::Logger
    finalizer :shutdown

    attr_reader :player_id
    attr_accessor :connection

    def self.find player_id
      Actor["session_#{player_id}"]
    end

    def self.role name, &block
      @role_definitions ||= {}
      @role_definitions[name.to_sym] = block
    end

    def self.create_roles player_id
      @role_definitions.map do |name, callback|
        name if callback.call(player_id)
      end
    end

    def initialize player_id
      @player_id = player_id
      Actor["session_#{player_id}"] = Actor.current
      @roles = Session.create_roles player_id
    end

    def receive message
      if authorized?(message)
        Actor[:message_dispatcher].async.dispatch(message, Actor.current)
      else
        raise "player #{player_id} is not authorized for #{message[:scope]}"
      end
    end

    def authorized?(message)
      @roles.include?(message[:scope].to_sym)
    end

    def send_message message
      connection.send_message message
    end

    def shutdown
      Actor.delete "session_#{player_id}"
    end

  end

end
