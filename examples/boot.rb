require_relative '../lib/sim'

require_relative 'event/simple_event'
require_relative 'message_handler/simple_handler'

Sim::Net::MessageHandler::Base.register_handler test: Example::SimpleHandler

Sim::Master.run
