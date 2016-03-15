SIM_ENV = ENV['SIM_ENV'] || 'development'

require 'rubygems'
require 'bundler/setup'
require 'celluloid'
require 'celluloid/io'

require_relative './sim/version'
