require_relative './sim.rb'

Celluloid::Actor[:guard] = Sim::Guard.new
queue = Sim::Queue.new

queue.start

5.times do |i|
  queue.add!(Sim::Object.new("Sim#{i}"))
  sleep 1
end

sleep 6

queue.stop

queue.objects.each do |object|
  puts "the end: sim #{object.name} #{object.state}"
end

queue.terminate

