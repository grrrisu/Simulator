"use strict";

const SocketService = require('simulator-middleware/client/socket_service.js');
const MonitorController = require('./monitor_controller.js');
const EventsChart = require('./events_chart.js');
const ErrorsChart = require('./errors_chart.js');

module.exports = class Game {

  constructor(){
    let socket = new SocketService().connect("http://localhost:8080", 123, 'abc-123');

    this.dispatch(socket);

    new MonitorController(socket);
  }

  dispatch(socket) {
    socket.on('example.*', function(data){
      console.log("data received", data);
      $('#messages').prepend('<div class="message">'+data.answer+'</div>');
    });

    let errorsChart = ErrorsChart();
    let errorCount = 0;

    socket.on('monitor.error', function(data){
      console.log("data received", data);
      let answer = data.answer;
      errorCount++;
      $('#errors').prepend('<div class="message">'+answer.component+': '+answer.error+' - '+answer.event+'</div>');
    });

    let processedEventsChart = EventsChart();

    socket.on('monitor.history', (data) => {
      processedEventsChart.series.addData(data.answer);
    	processedEventsChart.render();

      errorsChart.series.addData({errors: errorCount});
    	errorsChart.render();
      errorCount = 0;
    });

    socket.on('monitor.snapshot', function(data){
      console.log("snapshot", data);
      //$('#messages').append('<div class="message">'+data.answer+'</div>');
    });

    socket.on('net-status', function(data){
      $('#status').html('<div class="message">'+data.message+'</div>');
    });
  }

}
