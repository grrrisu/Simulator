require 'spec_helper'

describe Sim::Net::SubProcess do

  before :each do
    @receiver = double('Level')
    @process = Sim::Net::SubProcess.new
    @process.instance_variable_set('@receiver', @receiver)
  end

  describe 'receive_message' do

    before :each do
      allow(@process).to receive(:receive_data).and_return({action: 'foo'})
    end

    it "should forward message to receiver" do
      expect(@receiver).to receive(:dispatch).with({action: 'foo'}).and_return('bar')
      expect(@process).to receive(:send_message).with({answer: 'bar'})
      @process.receive_message
    end

    it "should send the exception message back" do
      expect(@receiver).to receive(:dispatch).with({action: 'foo'}).and_raise("process error")
      expect(@process).to receive(:send_message).with(exception: 'RuntimeError: process error')
      @process.receive_message
    end

  end

  describe 'listen_for_messages' do

    it "should not listen if not running" do
      @process.instance_variable_set('@running', false)
      expect(@process).to receive(:receive_message).never
      @process.listen_for_messages
    end

    it "should stop receiver if parent connection closed" do
      @process.instance_variable_set('@running', true)
      allow(@process).to receive(:receive_data) { raise EOFError }
      expect(@receiver).to receive(:stop_level)
      @process.listen_for_messages
    end

  end

  describe 'send_message' do

    it "should send message through stdout" do
      expect(@process).to receive(:send_data).with('foo')
      @process.send_message('foo')
    end

  end

end
