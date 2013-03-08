require 'spec_helper'

class PopenTestLevel < Sim::Level

  def process_message message
    if message == 'see all the stars'
      message.reverse
    else
      super
    end
  end

end

describe "popen" do

  it "should create a subprocess", focus: true do
    connection  = Sim::Popen::ParentConnection.new
    sim_library = File.expand_path('../../../sim.rb', __FILE__)
    level_class = 'PopenTestLevel'
    config_file = File.expand_path('../../../level.yml', __FILE__)
    connection.start(sim_library, level_class, config_file)
    answer = connection.send_message 'see all the stars'
    answer.should == 'see all the stars'.reverse
    connection.close
  end

end
