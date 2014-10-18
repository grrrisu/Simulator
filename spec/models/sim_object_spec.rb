require 'spec_helper'

describe Sim::Object do

  before :each do
    @now = Time.now
    Timecop.freeze(@now)
    Sim::TimeUnit.new(2)
    @object = DummyObject.build
  end

  describe 'touch' do

    it "should calcuate delay in time units" do
      Timecop.freeze(@now + 8)
      @object.touch
      @object.delay.should == 4
    end

  end

  describe 'sim' do

    it "should calcualte new size" do
      Timecop.freeze(@now + 8)
      @object.sim
      expect(@object.size).to eq(40)
    end

  end

end
