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
    @queue.size.should == @objects.size
  end

  describe 'add' do

    it "should increment queue objects" do
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

end
