require_relative '../../lib/sim'

class PopenTestLevel < Sim::Level

  def process_message message
    if message[:action] == 'see all the stars'
      message[:action].reverse
    else
      super
    end
  end

  def create config
    debug "creating..."
  end

end
