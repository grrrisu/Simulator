class Agent
  include Celluloid
  trap_exit :show_errors

  def show_errors(actor,reason)
    puts "********** Agent ************"
    p actor
    p reason
    puts "*********************************"
  end

  def initialize system
    @system = system
  end

  def think
    loop do
      look_around
      #move 1,1
    end
  end

  def look_around(field = rand(3))
    if @system.lock field
      $stdout.puts "agent #{self} looking around"
      sleep 2
    else
      sleep 0.1
      # retry
      $stdout.puts "retry look_around"
      look_around field
    end
  end

  def move x,y

  end
end
