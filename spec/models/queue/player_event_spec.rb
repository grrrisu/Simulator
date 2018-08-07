require 'spec_helper'

module Sim
  RSpec.describe Queue::PlayerEvent do

    it "should execute function" do
      event = Queue::PlayerEvent.new(123) do |player_id|
        "player with id #{player_id}"
      end

      expect(event.fire).to eq("player with id 123")
    end

  end
end
