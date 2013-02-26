require 'spec_helper'

describe Sim::TimeUnit do

  before :each do
    @time_unit = Sim::TimeUnit.new(2)
    @now = Time.now
  end

  it "should return 4 time units", focus: true do
    Time.stub(:now).and_return(@now, @now + 8, @now + 8, @now + 8, nil)
    @time_unit.start
    @time_unit.time_elapsed.should == 4
  end

  it "should return 7 time untis", focus: true do
    Time.stub(:now).and_return(@now, @now + 8, @now + 8, @now + 8, @now + 8 + 9, nil)
    #Time.stub(:now).and_return(@now, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8, @now + 8 + 9, nil)
    @time_unit.start
    @time_unit.time_elapsed.should == 4
    @time_unit.time_unit = 3
    @time_unit.time_elapsed.should == 7
  end

end
