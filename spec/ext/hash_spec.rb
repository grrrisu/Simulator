require 'spec_helper'

describe 'Hash' do

  let(:nested_array) { {'a' => 'a', 'b' => {'b1' => 1, 'b2' => 2}, 'c' => ['c1', {'c2' => 20, 'c3' => '30'}]} }
  let(:symbolized_nested_array) { {a: 'a', b: {b1: 1, b2: 2}, c:['c1', {c2: 20, c3: '30'}]} }

  it "should symbolize hash" do
    expect(
      nested_array.deep_transform_keys{ |key| key.to_sym rescue key }
    ).to eql(symbolized_nested_array)
  end

end
