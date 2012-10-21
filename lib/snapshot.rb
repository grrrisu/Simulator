require 'celluloid'

class Snapshot
  include Celluloid

  def initialize
    @changes = []
  end

  def listen changes
    #raise Exception, "snapshot crashed"
    @changes << changes#.value
  end

end
