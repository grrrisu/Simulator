class DummyPlayer < Sim::Player

  def view
    'view'
  end

  def crash
    raise "KAMIKAZE!!!"
  end

end
