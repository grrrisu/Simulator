require 'spec_helper'

describe "popen" do

  it "should create a subprocess" do
    connection  = Sim::Popen::ParentConnection.new
    sim_library = File.expand_path('../../support/popen_test_level.rb', __FILE__)
    level_class = 'PopenTestLevel'
    config_file = File.expand_path('../../level.yml', __FILE__)
    connection.start(sim_library, level_class, config_file)
    answer = connection.send_message 'see all the stars'
    answer.should == 'see all the stars'.reverse
    connection.close
  end

end
