require 'spec_helper'

describe Sim::Matrix do
  before(:each) do
    @matrix = Sim::Matrix.new(3, 4)
  end

  it "should get the dimensions of the matrix" do
    @matrix.size.should == [3,4]
  end

  it "should iterate over the matrix" do
    @matrix.set_each_field do
      1
    end
    @matrix.each_field do |field|
      field.should == 1
    end
  end

  it "should check boundaries for getter" do
    expect { @matrix[3,2] }.to raise_error(ArgumentError, "coordinates[3, 2] out of matrix[3, 4]")
  end

  it "should check boundaries for setter" do
    expect { @matrix[2,4] = 'foo' }.to raise_error(ArgumentError, "coordinates[2, 4] out of matrix[3, 4]")
  end

  it "should iterate over the matrix with index" do
    all = Array.new(3) { [0,1,2,3] }
    @matrix.each_field_with_index do |field, x, y|
      all[x].delete y
    end
    all.each {|row| row.should be_empty }
  end

  it "should set all fields with index" do
    @matrix.set_each_field_with_index do |x, y|
      [x, y]
    end
    4.times do |y|
      3.times {|x| @matrix[x,y].should == [x,y]}
    end
  end

  it "should set an object to a specific field" do
    @matrix.set_field(1,1,5)
    @matrix.get_field(1,1).should == 5
  end

  it "should set an object to a specific field using []" do
    @matrix[1,2] = 5
    @matrix[1,2].should == 5
  end

  it "should be enumerable" do
    collected = @matrix.collect {|f| f = 1}
    collected.each {|c| c.should == 1 }
  end

  it "should convert to json" do
    @matrix.set_each_field_with_index do |x, y|
      {:x => x, :y => y}
    end
    @matrix.flatten.should have(12).items
  end

  it "should convert to json" do
    @matrix.set_each_field_with_index do |x, y|
      {:x => x, :y => y}
    end
    @matrix.to_json.should be_instance_of(String)
    @matrix.to_json.should include("{\"x\":0,\"y\":0},{\"x\":1,\"y\":0}")
  end

  it "should slice" do
    @matrix.set_slice(1,1,2) { 1 }
    @matrix.slice(1,1,2) do |field|
      field.should == 1
    end
  end

  it "should slice with index" do
    @matrix.set_slice_with_index(1,1,2) {|x, y| [x,y]}
    @matrix.slice_with_index(1,1,2) do |field, x, y|
      field.should == [x,y]
    end
  end

  it "should set a slice" do
    @matrix.set_slice(1,1,2) { 1 }
    expected = [[nil, nil, nil], [nil, 1, 1], [nil, 1, 1], [nil, nil, nil]]
    @matrix.fields.should == expected
  end

  it "should set a slice with index" do
    @matrix.set_slice_with_index(1,1,2) {|x, y| [x,y]}
    expected = [[nil, nil, nil], [nil, [1,1], [2,1]], [nil, [1,2], [2,2]], [nil, nil, nil]]
    @matrix.fields.should == expected
  end

  it "should delegate methods" do
    @matrix.flatten.should == Array.new(12){nil}
    @matrix.inspect.should == '[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]'
    @matrix.to_s.should == '[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]'
  end

end
