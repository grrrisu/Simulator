require 'rubygems'
require 'bundler/setup'
require 'celluloid'
require 'active_support/core_ext'
require 'pry'
require 'logger'

require_relative './event.rb'
require_relative './sim_event.rb'
require_relative './sim_loop.rb'
require_relative './fire_worker.rb'
require_relative './event_queue.rb'
require_relative './master.rb'


module Sim
  module Queue

    Master.setup $stderr
    Master.launch 15, [1,2,3,4,5]
    Master.start

    event_queue = Celluloid::Actor[:event_queue]
    sim_loop = Celluloid::Actor[:sim_loop]

    sleep 1.5
    sim_loop << 6
    sleep 1.5
    sim_loop << 7
    sleep 1.5
    sim_loop.remove 1
    sleep 1.5
    sim_loop.remove 2
    sleep 20
    Master.stop
    #sleep 1
  end
end
