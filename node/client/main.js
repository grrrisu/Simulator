"use strict";

var $ = require('../bower_components/jquery/dist/jquery.min.js');

var SocketService = require('./socket_service.js');
var ReverseController = require('./reverse_controller.js');
var CrashController = require('./crash_controller.js');
var MonitorController = require('./monitor_controller.js');

class Game {

  constructor(){
    let socket_service = new SocketService();
    socket_service.connect("http://localhost:8080", 123, 'abc-123');
    new ReverseController(socket_service);
    new CrashController(socket_service);
    new MonitorController(socket_service);
  }

}

new Game();
