Celluloid.exception_handler do |exception|
  event = {event: exception.backtrace.first, error: exception.message}
  if monitor = Celluloid::Actor[:monitor]
    monitor.async.add_error event
  end
end
