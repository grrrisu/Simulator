require 'spec_helper'

describe Sim::Globe do

  let(:globe)   { Sim::Globe.new(15, 30) }

  describe "globe bounderies" do

    it "should check bounderies" do
      expect(globe.check_bounderies(0, 0)).to be == [0,0]
      expect(globe.check_bounderies(15, 30)).to be == [0, 0]
      expect(globe.check_bounderies(5, 10)).to be == [5, 10]
      expect(globe.check_bounderies(-5, -10)).to be == [14, 29]
      expect(globe.check_bounderies(25, 50)).to be == [0, 0]
    end

    it "should check bounderies" do
      expect(globe.around_position(0, 0)).to be == [0,0]
      expect(globe.around_position(15, 30)).to be == [0, 0]
      expect(globe.around_position(5, 10)).to be == [5, 10]
      expect(globe.around_position(-5, -10)).to be == [10, 20]
      expect(globe.around_position(25, 50)).to be == [10, 20]
      expect(globe.around_position(85, 170)).to be == [10, 20]
      expect(globe.around_position(-85, -170)).to be == [5, 10]
    end

    it "should set and get values outside the globe bounderies" do
      globe[25, 50] = 'outside is inside'
      expect(globe[25, 50]).to be == 'outside is inside'
    end

  end

end
