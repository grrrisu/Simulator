# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  puts e.message
  puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

load 'tasks/doc.rake'
load 'tasks/jeweler.rake'
load 'tasks/rspec.rake'
