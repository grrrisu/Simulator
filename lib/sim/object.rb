module Sim

  class Object

    attr_reader :delay
    attr_accessor :state, :name

    def initialize name = nil
      # just in order that @last_touched is not nil
      @last_touched = Time.now
      self.name  = name
      self.state = 0
    end

    def touch time = Time.now
      @delay =  (time - @last_touched) / TimeUnit.instance.time_unit
      @last_touched = time
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

end
