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
    expect(buildable).to respond_to(:size)
    expect(buildable).to respond_to(:min)
    expect(buildable).to respond_to(:max)
    expect(buildable).to respond_to(:hunger)
  end

  describe "mass set defaults" do
    it "should be build" do
      BuildableThree = Class.new(BuildableTest)
      BuildableThree.set_defaults size: 10, max: 15
      buildable = BuildableThree.build

      expect(buildable.size).to eq(10)
      expect(buildable.max).to eq(15)
    end
  end

  describe "build" do

    before :each do
      @buildable = BuildableTest.build @config, :min => 3
    end

    it "should overwrite all defaults if option is set" do
      expect(@buildable.min).to be == 3
    end

    it "should overwrite defaults if set in config" do
      expect(@buildable.hunger).to be == 6
    end

    it "should overwrite defaults from superclass" do
      expect(@buildable.size).to be == 7
    end

    it "should take defaults from superclass" do
      expect(@buildable.max).to be == 8
    end

  end

  describe "initialize parameters" do
    let(:config) { {x: 1, y: 2, factor: 5} }
    let(:buildable) { BuildableTwo.build(config) }

    it "should initialize with parameters" do
      expect(buildable.x).to be == 1
      expect(buildable.y).to be == 2
      expect(buildable.z).to be_nil
    end

    it "should do post build process" do
      expect(buildable.a).to be == 5
    end
  end

  describe "convert build values" do

    before(:each) do
      srand 0 # make random deterministic
    end

    it "should set value within range" do
      value = BuildableTest.convert_build_value(10..20)
      expect(value).to be == 15
    end

  end

end
