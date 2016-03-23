"use strict";

var $ = require('../bower_components/jquery/dist/jquery.min.js');

module.exports = class CrashController {

  constructor(socket) {
    this.bind_event(socket);
  }

  bind_event(socket) {
    $('#crash-form').on('submit', function(e){
      e.preventDefault();
      let action = {"scope": "example", "action": "crash" }
      socket.send_message(action);
    });
  }

}
