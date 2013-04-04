require 'spec_helper'

describe Sim::Popen::SubProcess do

  before :each do
    @receiver = mock('Level')
    @process = Sim::Popen::SubProcess.new
    @process.instance_variable_set('@receiver', @receiver)
  end

  describe 'receive_message' do

    before :each do
      @process.stub(:receive_data).and_return({'action' => 'foo'})
    end

    it "should forward message to receiver" do
      @receiver.should_receive(:process_message).with({'action' => 'foo'}).and_return('bar')
      @process.should_receive(:send_message).with({'answer' => 'bar'})
      @process.receive_message
    end

    it "should send the exception message back" do
      @receiver.should_receive(:process_message).with({'action' => 'foo'}).and_raise("process error")
      @process.should_receive(:send_message).with('exception' => 'RuntimeError: process error')
      $stderr.should_receive(:puts).with('[subprocess] ERROR: RuntimeError process error').once
      $stderr.should_receive(:puts).once # stacetrack
      @process.receive_message
    end

  end

  describe 'listen_for_messages' do

    it "should not listen if not running" do
      @process.instance_variable_set('@running', false)
      @process.should_receive(:receive_message).never
      @process.listen_for_messages
    end

    it "should stop receiver if parent connection closed" do
      @process.instance_variable_set('@running', true)
      @process.stub(:receive_data) { raise EOFError }
      @receiver.should_receive(:stop)
      $stderr.should_receive(:puts).once # log
      @process.listen_for_messages
    end

  end

  describe 'send_message' do

    it "should send message through stdout" do
      @process.should_receive(:send_data).with('foo')
      #$stderr.should_receive(:puts).once # log
      @process.send_message('foo')
    end

  end

end
