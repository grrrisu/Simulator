"use strict";

module.exports = class ReverseController {

  constructor(socket) {
    this.bind_event(socket);
  }

  bind_event(socket) {
    $('#reverse-form').on('submit', function(e){
      e.preventDefault();
      let message = $('#message').val();
      let action = {"scope": "example", "action": "reverse", "args": message }
      socket.send_message(action);
    });
  }

}
