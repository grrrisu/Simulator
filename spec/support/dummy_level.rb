require_relative '../../lib/sim'

class DummyLevel < Sim::Level

  attr_reader :players

  def reverse message
    message.reverse
  end

  def create config
    $stderr.puts "creating..."
  end

  def build_player data
    Sim::Player.new('123', self)
  end

  def add_player data
    player = build_player(data)
    (@players ||= []) << player
    player
  end

  def remove_player id
    raise "implement in subclass"
  end

  def find_player id
    @players.find {|player| player.id == id }
  end

end
