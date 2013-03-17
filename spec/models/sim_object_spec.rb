require 'spec_helper'

describe Sim::Object do

  before :each do
    @now = Time.now
    Timecop.freeze(@now)
    Sim::TimeUnit.new(2)
    @object = Sim::Object.new
  end

  describe 'touch' do

    it "should calcuate delay in time units" do
      Timecop.freeze(@now + 8)
      @object.touch
      @object.delay.should == 4
    end

  end

end
