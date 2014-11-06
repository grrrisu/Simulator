require 'spec_helper'

describe Sim::TimeUnit do

  before :each do
    @time_unit = Sim::TimeUnit.new(2)
    Celluloid::Actor[:time_unit] = @time_unit
    @now = Time.now
    Timecop.freeze(@now)
    @time_unit.start
  end

  it "should return instance" do
    expect(Sim::TimeUnit.instance.wrapped_object).to be_instance_of(Sim::TimeUnit)
  end

  it "should return 4 time units" do
    Timecop.freeze(@now + 8)
    expect(@time_unit.time_elapsed).to be == 4
  end

  it "should return 7 time untis" do
    Timecop.freeze(@now + 8)
    expect(@time_unit.time_elapsed).to be == 4
    @time_unit.time_unit = 3
    Timecop.freeze(@now + 8 + 9)
    expect(@time_unit.time_elapsed).to be == 7
  end

end
