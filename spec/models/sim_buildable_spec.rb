require 'spec_helper'

class BuildableSuperTest
  include Sim::Buildable
  default_attr :size, 5 #, :if => {|obj| obj.foo = 'bar'}, :type => String, track => TrackObserver
  default_attr :min, 4
  default_attr :max, 8
  default_attr :hunger, 1
end

class BuildableTest < BuildableSuperTest
  default_attr :size, 7
end

class BuildableTwo
  include Sim::Buildable

  attr_reader :x, :y, :z, :a

  def initialize x, y, z = nil
    @x, @y, @z = x, y, z
  end

  def build config
    @a = config[:factor] * x
  end

end

describe Sim::Buildable do

  before :all do
    @config = { min: 1, hunger: 6 }
  end

  it "should create accessors" do
    buildable = BuildableTest.build @config
    buildable.should respond_to(:size)
    buildable.should respond_to(:min)
    buildable.should respond_to(:max)
    buildable.should respond_to(:hunger)
  end

  describe "build" do

    before :each do
      @buildable = BuildableTest.build @config, :min => 3
    end

    it "should overwrite all defaults if option is set" do
      @buildable.min.should == 3
    end

    it "should overwrite defaults if set in config" do
      @buildable.hunger.should == 6
    end

    it "should overwrite defaults from superclass" do
      @buildable.size.should == 7
    end

    it "should take defaults from superclass" do
      @buildable.max.should == 8
    end

  end

  describe "initialize parameters" do
    let(:config) { {x: 1, y: 2, factor: 5} }
    let(:buildable) { BuildableTwo.build(config) }

    it "should initialize with parameters" do
      buildable.x.should == 1
      buildable.y.should == 2
      buildable.z.should be_nil
    end

    it "should do post build process" do
      buildable.a.should == 5
    end
  end

  describe "convert build values" do

    before(:each) do
      srand 0 # make random deterministic
    end

    it "should set value within range" do
      value = BuildableTest.convert_build_value(10..20)
      value.should == 15
    end

  end

end
