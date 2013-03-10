require_relative '../../lib/sim'

class PopenTestLevel < Sim::Level

  def process_message message
    if message == 'see all the stars'
      message.reverse
    else
      super
    end
  end

end
