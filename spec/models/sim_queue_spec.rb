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

  it "should have a filled queue" do
    @queue.size.should == @objects.size
  end

  describe 'add' do

    it "should add an object" do
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

  describe 'start' do

    before :each do
      @queue.stub(:next!).and_return('')
      @queue.stub(:next).and_return('')
    end

    it "should call next" do
      @queue.should_receive(:next)
      @queue.start
    end

    it "should touch every object", focus: true do
      @objects.each {|obj| obj.should_receive(:touch)}
      @queue.start
    end

  end

end
