"use strict";

const SocketService = require('simulator-middleware/client/socket_service.js');
const MonitorController = require('./monitor_controller.js');
const MonitorChart   = require('./monitor_chart.js');

module.exports = class Game {

  constructor(){
    let socket = new SocketService().connect("http://localhost:8080", 123, 'abc-123');

    this.dispatch(socket);

    new MonitorController(socket);
  }

  dispatch(socket) {
    socket.on('example.*', function(data){
      console.log("data received", data);
      let time = new Date().toLocaleString();
      $('#messages').prepend('<tr class="message"><td>'+time+'</td><td>'+data.answer+'</td></tr>');
    });

    let errorsChart = new MonitorChart({
      chartElementId: "errors-chart",
      palette: 'colorwheel',
      defaultSerie: 'errors',
      yAxisElementId: 'errors-y-axis'
    })
    errorsChart.render();
    let errorCount = 0;

    socket.on('monitor.error', function(data){
      console.log("data received", data);
      let answer = data.answer;
      errorCount++;
      let time = new Date().toLocaleString();
      $('#errors').prepend('<tr class="danger"><td>'+time+'</td><td>'+answer.component+': '+answer.error+' - '+answer.event+'</td></tr>');
    });

    let processedEventsChart = new MonitorChart({
      chartElementId: "processed-events-chart",
      palette: 'spectrum14',
      yAxisElementId: 'processed-events-y-axis'
    });
    processedEventsChart.render();

    socket.on('monitor.history', (data) => {
      processedEventsChart.update(data.summary);
    	this.updateInfo(data.snapshot);

      errorsChart.update({errors: errorCount});
    	errorCount = 0;
    });

    socket.on('monitor.snapshot', (data) => {
      console.log("snapshot", data);
      this.updateInfo(data.answer);
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

  updateInfo(snapshot){
    $('#sessions').html(snapshot.session_size);
    $('#time-unit').html(snapshot.time_unit);
    $('#objects').html(snapshot.object_size);
    $('#event-queue').html(snapshot.event_size);
  }

}
