require 'spec_helper'

describe "Sim" do

  before :each do
    Celluloid::Actor[:guard] = Guard.new
    @queue = SimQueue.new
    @objects = Array.new(3) do |i|
      object = mock(SimObject)
      object.stub!(:get_key).and_return(:a_key)
      object.stub!(:sim)
      #object.stub!(:lock).and_return(true)
      @queue << object
    end
  end

  it "should have a filled queue" do
    @queue.size.should == @objects.size
  end

  it "should sim each object" do
    @objects.each do |object|
      object.should_receive(:sim).once
    end
    @queue.start
    sleep 0.2
    @queue.stop
  end

end
