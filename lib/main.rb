require 'celluloid'

require_relative './sim/object'
require_relative './sim/worker'
require_relative './sim/queue'
require_relative './sim/guard'

Celluloid::Actor[:guard] = Sim::Guard.new
queue = SimQueue.new

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

