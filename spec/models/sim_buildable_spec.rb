require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestBuildableObject
  include Sim::Buildable
  @default = { :size => 200, :max => 12, :min => 3 }
  attr_accessor :size, :max, :min

  def initialize size = nil
    @size = size if size
  end
end

describe Sim::Buildable, skip: true do

  describe 'new' do

    it "should initialize with default value" do
      @object = TestBuildableObject.new
      @object.initialize_attributes @object.class.default_get
      @object.size.should == 200
      @object.max.should == 12
      @object.min.should == 3
    end

    it "should set default values" do
      @object = TestBuildableObject.new TestBuildableObject.build_options(:size)
      @object.size.should == 200
    end

    describe 'with level' do

      before :each do
        level = Sim::Level.build
        game = mock('Tournament::Game::Base')
        game.stub!(:time_unit).and_return(0.1)
        level.prepare game, 'TestBuildableObject' => {:size => 100, :max => 22}, 'Custom' => {:size => 33, :max => 44}
      end

      after :each do
        Sim::Level.clear
      end

      it "should create with build options" do
        @object = TestBuildableObject.new TestBuildableObject.build_options(:size)
        @object.size.should == 100
      end

      it "should return nil if key not found" do
        size = TestBuildableObject.build_options_for('NoClueObject', :size => 100)
        size.should be_nil
      end

      it "should create with custom value" do
        @object = TestBuildableObject.new
        @object.size, @object.max = TestBuildableObject.build_options_for('Custom', :size, :max)
        @object.size.should == 33
        @object.max.should == 44
      end

    end

  end

  describe 'build' do

    it "should build with options passed" do
      @object = TestBuildableObject.build :size => 50
      @object.size.should == 50
      @object.max.should == 12
      @object.min.should == 3
    end

    it "should build with defaults of super class" do
      subclass = Class.new(TestBuildableObject)
      object = subclass.build
      object.size.should == 200
      object.max.should == 12
      object.min.should == 3
    end

    describe 'with level' do

      before :each do
        level = Sim::Level.build
        game = mock('Tournament::Game::Base')
        game.stub!(:time_unit).and_return(0.1)
        level.prepare game, 'TestBuildableObject' => {:size => 100}, 'Custom' => {:size => 33, :max => 44}
      end

      after :each do
        Sim::Level.clear
      end

      it "should build with options passed" do
        @object = TestBuildableObject.build :max => 50
        @object.size.should == 100
        @object.max.should == 50
        @object.min.should == 3
      end

      it "should build with build_options" do
        @object = TestBuildableObject.build
        @object.size.should == 100
        @object.max.should == 12
        @object.min.should == 3
      end

      it "should build with custom options" do
        @object = TestBuildableObject.build_for 'Custom'
        @object.size.should == 33
        @object.max.should == 44
        @object.min.should == 3
      end

      it "should initialize with default if key not found" do
        @object = TestBuildableObject.build_for 'NoClue'
        @object.size.should == 200
        @object.max.should == 12
        @object.min.should == 3
      end

    end

  end

  describe "range values" do

    before(:each) do
      srand 0 # make random deterministic
    end

    it "should set value within range" do
      @object = TestBuildableObject.build :size => 10..20
      @object.size.should == 15
    end

  end

end
