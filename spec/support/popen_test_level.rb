require_relative '../../lib/sim'

class PopenTestLevel < Sim::Level

  def reverse message
    message.reverse
  end

  def create config
    $stderr.puts "creating..."
  end

end
