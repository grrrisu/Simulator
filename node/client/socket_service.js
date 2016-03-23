"use strict";

var io = require('../node_modules/socket.io/node_modules/socket.io-client/socket.io.js');
var $ = require('../bower_components/jquery/dist/jquery.min.js');

module.exports = class SocketService {

  connect(url, player_id, token) {

    this.socket = io.connect(url);

    this.socket.on("connect", (data) => {
      console.log("connected to server " + url);
      this.socket.emit("join", player_id, token);
    });

    this.socket.on("action", (data) => {
      data = JSON.parse(data);
      console.log("data received", data);
      $('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    this.socket.on("end", () => {
      console.log("reloading");
      window.location.href = window.location.href;
    });

    this.socket.on("net-status", (data) => {
      $('#messages').append('<div class="message">'+data.message+'</div>');
    });

    return this.socket;

  }

  send_message(message){
    this.socket.emit("action", message);
  }

}
