"use strict";

import $ from 'jquery';

module.exports = class Receiver {

  constructor(socket){
    this.socket = socket;
    this.listen(socket);
  }

  this.listen(socket){
    socket.on('game_of_life.*', function(data){
      console.log("data received", data);
      let time = new Date().toLocaleString();
      $('#messages').prepend('<tr class="message"><td>'+time+'</td><td>'+data.answer+'</td></tr>');
    });
  }

}
