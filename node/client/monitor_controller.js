"use strict";

module.exports = class MonitorController {

  constructor(socket) {
    this.bind_event(socket);
  }

  bind_event(socket) {
    $('#button-reverse').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "example", "action": "reverse", "args": "hello world"}
      socket.send_message(action);
    });

    $('#button-crash').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "example", "action": "crash"}
      socket.send_message(action);
    });

    $('#button-wait').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "example", "action": "wait"}
      socket.send_message(action);
    });
  }

}
