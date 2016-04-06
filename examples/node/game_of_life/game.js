"use strict";

import $ from 'jquery';

import SocketService from 'simulator-middleware/client/socket_service.js';
import controller from './controller.js';
import dispatcher from './receiver.js';

module.exports = class Game {

  constructor(){
    let socket = new SocketService().connect("http://localhost:8080", 123, 'abc-123');
    new Controller(socket);
    new Receiver(socket);

    this.bindNetStatus(socket);
  }

  bindNetStatus(socket){
    socket.on_connect_error( (data) => {
      $('#net-status').html('<div class="message alert alert-danger">middleware not available</div>');
    });

    socket.on('net-status', (data) => {
      let status_css = "";
      if(data.key == 'server_connected'){
        status_css = "alert-success";
      } else {
        status_css = "alert-danger";
      }
      $('#net-status').html('<div class="message alert ' + status_css + '">'+data.message+'</div>');
    });
  }

}
