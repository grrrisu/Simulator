"use strict";

const $ = require('../bower_components/jquery/dist/jquery.min.js');

const SocketService = require('./socket_service.js');
const MonitorController = require('./monitor_controller.js');

class Game {

  constructor(){
    let socket_service = new SocketService();
    socket_service.connect("http://localhost:8080", 123, 'abc-123');
    new MonitorController(socket_service);
  }

}

new Game();
