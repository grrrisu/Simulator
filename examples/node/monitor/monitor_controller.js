"use strict";

import $ from 'jquery';

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

    $('#monitor-subscribe').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "monitor", "action": "subscribe"}
      socket.send_message(action);
    });

    $('#monitor-unsubscribe').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "monitor", "action": "unsubscribe"}
      socket.send_message(action);
    });

    $('#monitor-snapshot').on('click', function(e){
      e.preventDefault();
      let action = {"scope": "monitor", "action": "snapshot"}
      socket.send_message(action);
    });
  }

}
