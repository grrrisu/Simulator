module Sim
  class Master < Celluloid::SupervisionGroup
    supervise Monitor, as: :monitor, args: [{}]
    supervise Queue::SimMaster, as: :sim_master, args: [{}]
    supervise Queue::EventQueue, as: :event_queue
    supervise Net::MessageDispatcher, as: :message_dispatcher
    supervise Net::Broadcaster, as: :broadcaster
    # TODO read from config yml
    socket_file = File.join(__dir__, '..', '..', 'tmp', 'sockets', 'player.sock')
    supervise Net::PlayerServer, as: :player_server, args: [socket_file, {start: true}]
  end
end

Celluloid.exception_handler do |exception|
  event = {event: exception.backtrace.first, error: exception.message}
  if monitor = Celluloid::Actor[:monitor]
    monitor.async.add_error event
  end
end
