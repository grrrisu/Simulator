"use strict";

module.exports = class CrashController {

  constructor(socket) {
    this.bind_event(socket);
  }

  bind_event(socket) {
    $('#crash-form').on('submit', function(e){
      e.preventDefault();
      let action = {"scope": "test", "action": "crash" }
      socket.send_message(action);
    });
  }

}
