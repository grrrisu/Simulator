require 'spec_helper'

module Sim
  RSpec.describe Queue::TimeUnit do

    let(:time_unit) { Queue::TimeUnit.new(seconds: 2) }
    let(:now)       { Time.now }

    before :each do
      Timecop.freeze(now)
      time_unit.start
    end

    it "should return 4 time units" do
      Timecop.freeze(now + 8)
      expect(time_unit.time_elapsed).to be == 4
    end

    it "should return 7 time untis" do
      Timecop.freeze(now + 8)
      expect(time_unit.time_elapsed).to be == 4
      time_unit.time_unit = 3
      Timecop.freeze(now + 8 + 9)
      expect(time_unit.time_elapsed).to be == 7
    end

    it "should restart" do
      Timecop.freeze(now + 6)
      time_unit = Queue::TimeUnit.new(seconds: 2, units_since_start: 3)
      time_unit.start
      Timecop.freeze(now + 10)
      expect(time_unit.time_elapsed).to be == 5
    end

    it "should resume" do
      #time_unit.stop
      Timecop.freeze(now + 6)
      time_unit.resume
      Timecop.freeze(now + 10)
      expect(time_unit.time_elapsed).to be == 2
    end

    it "should generate json" do
      expect(Queue::TimeUnit.new(seconds: 3).as_json).to eq({time_unit: 3, time_elapsed: 0.0, started: nil})
      expect(Queue::TimeUnit.new(seconds: 3, units_since_start: 5).as_json).to eq({time_unit: 3, time_elapsed: 5.0, started: nil})
      expect(time_unit.as_json).to be == {time_unit: 2, time_elapsed: 0.0, started: now.iso8601}
    end

  end
end
