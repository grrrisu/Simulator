require_relative '../lib/sim'

require_relative 'event/reverse_event'
require_relative 'event/crash_event'
require_relative 'event/wait_event'
require_relative 'message_handler/handler'

Sim::Net::Router.define do |router|

  router.forward :example, to: Example::Handler

  router.forward :admin, to: Sim::Net::MessageHandler::Admin do |player_id|
    player_id.to_i == 123
  end
  
  router.forward :monitor, to: Sim::Net::MessageHandler::Monitor do |player_id|
    player_id.to_i == 123
  end

end

Sim::Master.run
