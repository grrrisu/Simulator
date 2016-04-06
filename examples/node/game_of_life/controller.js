"use strict";

import $ from 'jquery';

module.exports = class Controller {

  constructor(socket){
    this.socket = socket;
    this.bind_events();
  }

  bind_events(){
    $('#button-build').on('click', (e) => {
      e.preventDefault();
      let size      = +$('#size').val() || 8;
      let timeunit  = +$('#timeunit').val() || 1.0;
      let message = {"scope": "game_of_life", "action": "build", "args": {timeunit: timeunit, size: size}}
      socket.send_message(message);
    });

    $('#button-start').on('click', (e) => {
      e.preventDefault();
      let message = {"scope": "game_of_life", "action": "start"}
      socket.send_message(message);
    });

    $('#button-stop').on('click', (e) => {
      e.preventDefault();
      let message = {"scope": "game_of_life", "action": "stop"}
      socket.send_message(message);
    });
  }

}
