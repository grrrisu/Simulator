"use strict";

var $ = require('jquery/dist/jquery.min.js');

const SocketService = require('simulator-middleware/client/socket_service.js');
const MonitorController = require('./monitor_controller.js');

class Game {

  constructor(){
    let socket = new SocketService().connect("http://localhost:8080", 123, 'abc-123');

    socket.on('example.*', function(data){
      console.log("data received", data);
      $('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('monitor.error', function(data){
      console.log("data received", data);
      $('#errors').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('monitor.history', function(data){
      console.log("history", data);
      //$('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('monitor.snapshot', function(data){
      console.log("snapshot", data);
      //$('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('net-status', function(data){
      $('#status').html('<div class="message">'+data.message+'</div>');
    });

    new MonitorController(socket);
  }

}

new Game();
