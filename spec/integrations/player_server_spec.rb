require 'spec_helper'

describe "player server" do

  let(:socket_path) { 'tmp/player_server.sock' }
  let(:client)      { Sim::Net::PlayerProxy.new('123', :player) }
  let(:level)       { DummyLevel.instance }
  let!(:server)     { Sim::Net::PlayerServer.new(level, socket_path)}

  it "should register a new player" do
    EM.run do
      client.connect_to_players_server(socket_path)
      EM.next_tick { client.send_message(:crash) }
      EM.next_tick { client.send_message(:view, x: 1, y: 0) }
      EM.add_timer(2) { EM.stop }
    end
    expect(level.players).to_not be_empty
    expect(level.players['123']).to_not be_nil
  end



end
