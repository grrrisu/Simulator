require 'celluloid'

puts 'preparing...'

require './sim_queue'
require './sim_system'
require './sim_worker'
require './sim_object'
require './snapshot'
require './agent'
=begin
Dir["#{File.dirname(__FILE__)}/*.rb"].uniq.each do |file|
  puts file
  require file
end
=end

# test scenario: 5 workers, 10 sim object takes 5 sec, 3 locks
# at most 3 workers can sim an object (because of the locks)
# workers loop needs at least 15 sec to delegate the work (3 x 5 sec)
# sim loop takes also


queue = SimQueue.new
# registered as :queue
Celluloid::Actor[:queue] = queue
system = SimSystem.new
objects = (0..10).map { system << SimObject.new(system) }
agents  = (0..5).map { Agent.new(system) }

puts "starting queue..."
queue.start
sleep 20
system.add(SimObject.new(system))
sleep 10
system.remove(objects.last)
sleep 20

#p queue.snapshot

agents.each(&:terminate)
queue.stop
system.terminate

