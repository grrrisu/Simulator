"use strict";

import $ from 'jquery';

module.exports = class Controller {

  constructor(socket){
    this.socket = socket;
    this.bind_events();
    this.request_initial_state();
  }

  bind_events(){
    $('#button-build').on('click', (e) => {
      e.preventDefault();
      let size      = +$('#size').val() || 8;
      let duration  = +$('#duration').val() || 1.0;
      let message = {"scope": "game_of_life", "action": "build", "args": [duration, size]}
      this.socket.send_message(message);
    });

    $('#button-start').on('click', (e) => {
      e.preventDefault();
      let message = {"scope": "game_of_life", "action": "start"}
      this.socket.send_message(message);
    });

    $('#button-stop').on('click', (e) => {
      e.preventDefault();
      let message = {"scope": "game_of_life", "action": "stop"}
      this.socket.send_message(message);
    });
  }

  request_initial_state(){
    let message = {"scope": "game_of_life", "action": "init"}
    this.socket.send_message(message);
  }

}
