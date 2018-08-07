require 'spec_helper'

module Sim
  RSpec.describe Sim::Object do

    let(:time_unit) { Queue::TimeUnit.new(seconds: 2) }
    let(:now)       { Time.now }
    let(:object)    { DummyObject.build }

    before :each do
      Timecop.freeze(now)
      Celluloid::Actor[:time_unit] = time_unit
      time_unit.start
    end

    describe 'touch' do

      it "should calcuate delay in time units" do
        Timecop.freeze(now + 8)
        expect(object).to receive(:sim)
        object.update_simulation
        expect(object.delay).to be == 4
      end

    end

    describe 'sim' do

      it "should calcualte new size" do
        Timecop.freeze(now + 8)
        object.update_simulation
        expect(object.size).to eq(40)
      end

    end

  end
end
