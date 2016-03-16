require 'spec_helper'

describe Sim::Object do

  before :each do
    @now = Time.now
    Timecop.freeze(@now)
    Celluloid::Actor[:time_unit] = Sim::TimeUnit.new(2)
    @object = DummyObject.build
  end

  describe 'touch' do

    it "should calcuate delay in time units" do
      Timecop.freeze(@now + 8)
      expect(@object).to receive(:sim)
      @object.update_simulation
      expect(@object.delay).to be == 4
    end

  end

  describe 'sim' do

    it "should calcualte new size" do
      Timecop.freeze(@now + 8)
      @object.update_simulation
      expect(@object.size).to eq(40)
    end

  end

end
