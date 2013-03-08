require 'spec_helper'

describe Sim::Popen::SubProcess do

  before :each do
    @receiver = mock('Level')
    @process = Sim::Popen::SubProcess.new
    @process.instance_variable_set('@receiver', @receiver)
  end

  describe 'receive_message' do

    before :each do
      $stdin.stub(:readline).and_return("foo\n")
    end

    it "should forward message to receiver" do
      @receiver.should_receive(:process_message).with('foo').and_return('bar')
      @process.should_receive(:send_message).with('bar')
      @process.receive_message
    end

    it "should send the exception message back" do
      @receiver.should_receive(:process_message).with('foo').and_raise("process error")
      @process.should_receive(:send_message).with("exception 'process error' occured in subprocess")
      $stderr.should_receive(:puts).with('[subprocess] ERROR: RuntimeError process error').once
      $stderr.should_receive(:puts).once # stacetrack
      @process.receive_message
    end

  end

  describe 'listen' do

    it "should not listen if not running" do
      @process.instance_variable_set('@running', false)
      @process.should_receive(:receive_message).never
      @process.listen
    end

    it "should stop receiver if parent connection closed" do
      @process.instance_variable_set('@running', true)
      $stdin.stub(:readline) { raise EOFError }
      @receiver.should_receive(:stop)
      $stderr.should_receive(:puts).once # log
      @process.listen
    end

  end

  describe 'send_message' do

    it "should send message through stdout" do
      $stdout.should_receive(:puts).with('foo')
      $stderr.should_receive(:puts).once # log
      @process.send_message('foo')
    end

  end

end
