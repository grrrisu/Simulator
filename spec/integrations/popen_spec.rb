require 'spec_helper'

describe "popen" do

  it "should create a subprocess", skip: true do
    level = Sim::Popen::SubProcess.start
  end

end
