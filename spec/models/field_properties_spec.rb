require 'spec_helper'

describe Sim::FieldProperties do

  let(:field) { Sim::FieldProperties.new }

  it "should have property accessors" do
    expect(field.vegetation?).to be false
    field.vegetation = 'jungle'
    expect(field.vegetation).to be == 'jungle'
    expect(field.vegetation?).to be true
    field.vegetation = nil
    expect(field.vegetation?).to be false
  end

end
