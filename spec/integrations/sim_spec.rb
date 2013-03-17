require 'spec_helper'

describe "Sim" do

  before :each do
    Sim::TimeUnit.new(5)
    Celluloid::Actor[:guard] = Sim::Guard.new
    @queue = Sim::Queue.new
    @objects = Array.new(2) do |i|
      object = DummyObject.new
      object.stub(:sim)
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
