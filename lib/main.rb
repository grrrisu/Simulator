require 'celluloid'

require_relative './sim_object'
require_relative './sim_worker'
require_relative './sim_queue'
require_relative './semaphore'

Celluloid::Actor[:semaphore] = Semaphore.new
queue = SimQueue.new

queue.start

5.times do |i|
  queue.add!(SimObject.new("Sim#{i}"))
  sleep 1
end

sleep 6

queue.stop

queue.objects.each do |object|
  puts "the end: sim #{object.name} #{object.state}"
end

queue.terminate

