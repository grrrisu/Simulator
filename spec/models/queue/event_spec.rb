require 'spec_helper'

describe Sim::Queue::Event, focus: true do

  let (:event) { Sim::Queue::Event.new('object') }

  describe "fire" do

    it "should be done" do
      event.should_not be_done
      event.done!
      event.should be_done
    end

  end

end
