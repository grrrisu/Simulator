class DummyObject < Sim::Object

  attr_accessor :name, :state

  def initialize name = nil
    super()
    self.name  = name
    self.state = 0
  end

  def parent_guard
    Celluloid::Actor[:guard]
  end

  def get_key
    :a_key
  end

  def sim
    5.times do |i|
      self.state += 1
      puts "sim #{name} #{state}"
      sleep 1
    end
    puts 'done!'
    #raise Exception, "CRASH"
  end

end
