require 'spec_helper'

describe Sim::Queue do

  before :each do
    @queue = Sim::Queue.new
    @objects = Array.new(3) do |i|
      object = mock(Sim::Object)
      object.stub!(:sim)
      object.stub!(:lock).and_return(true)
      @queue << object
    end
  end

  it "should have a filled queue" do
    @queue.size.should == @objects.size
  end

  # it "should sim each object" do
  #   pending
  # end

end
