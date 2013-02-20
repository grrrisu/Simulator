module Sim

  class Object

    attr_accessor :state, :name

    def initialize name = nil
      self.name  = name
      self.state = 0
    end

    def touch
      @last_touched = Time.now
    end

    def parent_guard
      Celluloid::Actor[:guard]
    end

    def get_key
      :a_key
    end

    def delay time = Time.now
      delay =  time - @last_touched
      @last_touched = time
      delay
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

end
