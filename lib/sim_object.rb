class SimObject

  attr_accessor :state, :name

  def initialize name = nil
    self.name  = name
    self.state = 0
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
