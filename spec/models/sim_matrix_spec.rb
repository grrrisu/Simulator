require 'spec_helper'

describe Sim::Matrix do

  let(:matrix) { Sim::Matrix.new(3, 4) }

  it "should get the dimensions of the matrix" do
    expect(matrix.size).to be == [3,4]
  end

  it "should iterate over the matrix" do
    matrix.set_each_field do
      1
    end
    matrix.each_field do |field|
      expect(field).to be == 1
    end
  end

  it "should check boundaries for getter" do
    expect { matrix[3,2] }.to raise_error(ArgumentError, "coordinates x:3, y:2 out of matrix width:3, height:4")
  end

  it "should check boundaries for setter" do
    expect { matrix[2,4] = 'foo' }.to raise_error(ArgumentError, "coordinates x:2, y:4 out of matrix width:3, height:4")
  end

  it "should iterate over the matrix with index" do
    all = Array.new(3) { [0,1,2,3] }
    matrix.each_field_with_index do |field, x, y|
      all[x].delete y
    end
    all.each {|row| expect(row).to be_empty }
  end

  it "should set all fields with index" do
    matrix.set_each_field_with_index do |x, y|
      [x, y]
    end
    4.times do |y|
      3.times {|x| expect(matrix[x,y]).to be == [x,y]}
    end
  end

  it "should set an object to a specific field" do
    matrix.set_field(1,1,5)
    expect(matrix.get_field(1,1)).to be == 5
  end

  it "should set an object to a specific field using []" do
    matrix[1,2] = 5
    expect(matrix[1,2]).to be == 5
  end

  it "should be enumerable" do
    collected = matrix.collect {|f| f = 1}
    collected.each {|c| expect(c).to be == 1 }
  end

  it "should convert to json" do
    matrix.set_each_field_with_index do |x, y|
      {:x => x, :y => y}
    end
    expect(matrix.flatten.size).to be == 12
  end

  it "should convert to json" do
    matrix.set_each_field_with_index do |x, y|
      {:x => x, :y => y}
    end
    expect(matrix.to_json).to be_instance_of(String)
    expect(matrix.to_json).to include("{\"x\":0,\"y\":0},{\"x\":1,\"y\":0}")
  end

  it "should slice" do
    matrix.set_slice(1,1,2) { 1 }
    matrix.slice(1,1,2) do |field|
      expect(field).to be == 1
    end
  end

  it "should slice with index" do
    matrix.set_slice_with_index(1,1,2) {|x, y| [x,y]}
    matrix.slice_with_index(1,1,2) do |field, x, y|
      expect(field).to be == [x,y]
    end
  end

  it "should set a slice" do
    matrix.set_slice(1,1,2) { 1 }
    expected = [[nil, nil, nil], [nil, 1, 1], [nil, 1, 1], [nil, nil, nil]]
    expect(matrix.fields).to be == expected
  end

  it "should set a slice with index" do
    matrix.set_slice_with_index(1,1,2) {|x, y| [x,y]}
    expected = [[nil, nil, nil], [nil, [1,1], [2,1]], [nil, [1,2], [2,2]], [nil, nil, nil]]
    expect(matrix.fields).to be == expected
  end

  it "should delegate methods" do
    expect(matrix.flatten).to be == Array.new(12){nil}
    expect(matrix.inspect).to be == '[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]'
    expect(matrix.to_s).to be == '[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]'
  end

  describe 'equal' do

    let(:equal_array)    { [[1,2,3], [4,5,6], [7,8,9]] }
    let(:differnt_array) { [[9,8,7], [6,5,4], [3,2,1]] }

    it "should check equality with another matrix" do
      matrix.matrix = equal_array
      other = Sim::Matrix.new 9

      other.matrix  = equal_array
      expect(matrix).to be == other

      other.matrix = differnt_array
      expect(matrix).to_not be == other
    end

    it "should check equality with another array" do
      matrix.matrix = equal_array
      expect(matrix).to be == equal_array
      expect(matrix).to_not be == differnt_array
    end

    it "should check equality with something else" do
      expect(matrix).to_not be == Object.new
    end

  end

end
