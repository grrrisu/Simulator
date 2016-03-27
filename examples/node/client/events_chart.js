"use strict";

module.exports = function(){

  let processedPalette = new Rickshaw.Color.Palette( { scheme: 'spectrum2000' } );

  let processedEventsChart = new Rickshaw.Graph( {
    element: document.getElementById("processed-events-chart"),
    width: 650,
    height: 200,
    renderer: 'bar',
    stroke: true,
    series: new Rickshaw.Series.FixedDuration([{ name: 'one' }], undefined, {
      color: processedPalette.color(),
      timeInterval: 10000,
      maxDataPoints: 100,
      timeBase: new Date().getTime() / 1000
    })
  } );

  let processed_y_ticks = new Rickshaw.Graph.Axis.Y( {
    graph: processedEventsChart,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    element: document.getElementById('processed-events-y-axis')
  } );

  let processedHoverDetail = new Rickshaw.Graph.HoverDetail({
    graph: processedEventsChart
  });

  processedEventsChart.render();

  return processedEventsChart;
}
