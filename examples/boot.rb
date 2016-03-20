require_relative '../lib/sim'

require_relative 'event/simple_event'
require_relative 'message_handler/simple_handler'

Sim::Net::Router.define do |router|

  router.forward :test, to: Example::SimpleHandler

  router.forward :admin, to: Example::SimpleHandler do |player_id|
    player_id.to_i == 123
  end

end

Sim::Master.run
