require_relative '../lib/sim'

require_relative 'event/simple_event'
require_relative 'message_handler/simple_handler'

Sim::Net::MessageDispatcher.register_handler test: Example::SimpleHandler

Sim::Session.role(:test) do |player_id|
  false
end
Sim::Session.role(:admin) do |player_id|
  player_id.to_i == 123
end

Sim::Master.run
