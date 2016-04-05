"use strict";

var io = require('socket.io/node_modules/socket.io-client');
var EventEmitter2 = require('eventemitter2').EventEmitter2;

module.exports = class SocketService extends EventEmitter2 {

  constructor(){
    super({wildcard: true});
  }

  connect(url, player_id, token) {

    this.socket = io.connect(url);

    this.socket.on("connect", (data) => {
      console.log("connected to server " + url);
      this.socket.emit("join", player_id, token);
    });

    this.socket.on("action", (data) => {
      data = JSON.parse(data);
      this.emit([data.scope, data.action], data);
    });

    this.socket.on("net-status", (data) => {
      this.emit('net-status', data);
    });

    return this;

  }

  send_message(message){
    this.socket.emit("action", message);
  }

  on_connect_error(callback){
    this.socket.on("connect_error", (data) => {
      console.log("middleware connect error");
      callback(data);
    });

    this.socket.on("disconnect", (data) => {
      console.log("middleware disconnected");
      callback(data);
    });
  }

}
