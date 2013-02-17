require 'spec_helper'

describe "Sim" do

  before :each do
    Celluloid::Actor[:semaphore] = Semaphore.new
    @queue = SimQueue.new
    @objects = Array.new(3) do |i|
      object = SimObject.new
      object.stub!(:sim)
      @queue << object
      object
    end
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
