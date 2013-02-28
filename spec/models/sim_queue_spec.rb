require 'spec_helper'

describe Sim::Queue do

  before :each do
    @queue = Sim::Queue.new
    @objects = Array.new(3) do |i|
      object = Sim::Object.new
      object.stub!(:sim)
      @queue << object
      object
    end
  end

  after :each do
    @queue.terminate
  end

  it "should have a filled queue" do
    Sim::TimeUnit.new(5)
    @queue.size.should == @objects.size
  end

  describe 'add' do

    it "should increment queue objects" do
      Sim::TimeUnit.new(5)
      lambda {
        @queue << Sim::Object.new
      }.should change(@queue, :size).by(1)
    end

    it "should touch adding object" do
      object = Sim::Object.new
      object.should_receive(:touch)
      @queue << object
    end

  end

  describe 'remove' do

    it "should dec queue objects" do
      object = Sim::Object.new
      @queue.add(object)
      lambda {
        @queue.remove(object)
      }.should change(@queue, :size).by(-1)
    end

  end

  describe 'start' do

    before :each do
      @queue.wrapped_object.stub(:next!).and_return('')
    end

    it "should call next" do
      @queue.wrapped_object.should_receive(:next!)
      @queue.start
    end

    it "should touch every object" do
      @objects.each {|obj| obj.should_receive(:touch)}
      @queue.start
    end

  end

  describe 'stop' do

    it "should wait for busy workers" do
      @queue.wrapped_object.should_receive(:wait_for_busy_workers)
      @queue.stop
    end

    it "should not call for a worker" do
      @queue.wrapped_object.instance_variable_get("@pool").should_receive(:process!).never
      @queue.stop
      @queue.next
    end

  end

  describe 'next' do

  end

  describe 'wait_before_next_loop' do

    before :all do
      Sim::TimeUnit.new(5)
    end

    before :each do
      @now = Time.now
      Timecop.freeze(@now)
      @queue.wrapped_object.instance_variable_set('@last_run', @now - 5)
    end

    after :all do
      Celluloid::Actor[:time_unit].terminate
    end

    it "should calculate time for next loop" do
      @queue.wrapped_object.stub(:max_time).and_return(10)
      #@queue.wait_before_next_loop.should == 5
    end

    it "should not extend time unit after the first delay" do
      @queue.wrapped_object.instance_variable_set('@late_again', 0)
      @queue.wrapped_object.stub(:max_time).and_return(3)
      @queue.wait_before_next_loop.should == 0
      @queue.wrapped_object.instance_variable_get('@late_again').should == 1
    end

    it "should extend time unit after 3 delays in a row" do
      @queue.wrapped_object.instance_variable_set('@late_again', 3)
      @queue.wrapped_object.stub(:max_time).and_return(3)
      @queue.wait_before_next_loop.should == 0
      Celluloid::Actor[:time_unit].time_unit.should == 25
    end

    it "should extend time unit after 3 delays in a row" do
      @queue.wrapped_object.instance_variable_set('@priority', 1.5) # low priority
      @queue.wrapped_object.instance_variable_set('@late_again', 3)
      @queue.wrapped_object.stub(:max_time).and_return(3)
      @queue.wait_before_next_loop.should == 0
      Celluloid::Actor[:time_unit].time_unit.should > 5
    end


  end

end
