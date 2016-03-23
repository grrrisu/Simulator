# Sim::Net::Router.define do |router|
#
#   router.forward :test, to: Example::SimpleHandler
#
#   router.forward :admin, to: Example::SimpleHandler do |player_id|
#     player_id.to_i == 123
#   end
#
# end

module Sim
  module Net

    class Router

      def self.define
        yield new
      end

      def forward name, to:, &block
        MessageDispatcher.register_handler name.to_sym, to
        Session.role(name.to_sym) do |player_id|
          block || proc { true }
        end
      end

    end

  end
end
