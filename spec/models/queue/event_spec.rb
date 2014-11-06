require 'spec_helper'

describe Sim::Queue::Event do

  let (:event) { Sim::Queue::SimEvent.new('object') }

  describe "fire" do

    it "should be done" do
      expect(event).to_not be_done
      event.done!
      expect(event).to be_done
    end

  end

end
