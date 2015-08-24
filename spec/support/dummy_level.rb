require_relative '../../lib/sim'

class DummyLevel < Sim::Level

  def reverse message
    message.reverse
  end

  def create config
    puts "creating..."
    true
  end

  def build_player data
    Sim::Player.new('123', self)
  end

  def add_player data
    player = build_player(data)
    @players[player.id] = player
  end

  def remove_player id
    raise "implement in subclass"
  end

  def find_player id
    @players.values.find {|player| player.id == id }
  end

end
