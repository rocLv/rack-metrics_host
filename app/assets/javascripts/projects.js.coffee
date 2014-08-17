# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/

type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = {
    '[object Boolean]': 'boolean',
    '[object Number]': 'number',
    '[object String]': 'string',
    '[object Function]': 'function',
    '[object Array]': 'array',
    '[object Date]': 'date',
    '[object RegExp]': 'regexp',
    '[object Object]': 'object'
  }
  return classToType[Object.prototype.toString.call(obj)]

charts = {}
uri = URI(document.URL)

d3_charts = ->
  uri.pathname("#{uri.pathname()}.json")
  charts.response_time = line_chart('Response Time (ms)')
  charts.response_time_2 = line_chart('Response Time (ms)')
  charts.rpm = line_chart('Requests per minute')
  charts.memory = line_chart('Memory usage(MB)')
  $.getJSON uri.toString(), (data) ->
    d3line(data['response_time'], '#response_time svg', charts.response_time)
    d3line(data['response_time_2'], '#response_time_2 svg', charts.response_time_2)
    d3line(data['rpm'], '#rpm svg', charts.rpm)
    d3line(data['memory'], '#memory svg', charts.memory)
  setInterval( (-> d3_line_refresh()), 30000) unless uri.hasQuery('filter[to]')

d3_line_refresh = (chart) ->
  $.getJSON uri.toString(), (data) ->
    d3.select('#response_time svg')
    .datum(data['response_time'])
    # .transition().duration(500)
    .call(charts.response_time);
    d3.select('#response_time_2 svg')
    .datum(data['response_time_2'])
    # .transition().duration(500)
    .call(charts.response_time_2);
    d3.select('#rpm svg')
    .datum(data['rpm'])
    # .transition().duration(500)
    .call(charts.rpm);
    d3.select('#memory svg')
    .datum(data['memory'])
    # .transition().duration(500)
    .call(charts.memory);
# /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
response_time = () ->
  nv.addGraph(
    ->
      chart = charts.response_time
      d3.select(target)    #Select the <svg> element you want to render the chart in.
        .datum(data)         #Populate the <svg> element with chart data...
        .call(chart);          #Finally, render the chart!
      #Update the chart when window resizes.
      nv.utils.windowResize ->
        chart.update()
      chart;
  )
d3line = (data, target, chart) ->
  nv.addGraph(
    ->
      d3.select(target)    #Select the <svg> element you want to render the chart in.
        .datum(data)         #Populate the <svg> element with chart data...
        .call(chart);          #Finally, render the chart!
      #Update the chart when window resizes.
      nv.utils.windowResize ->
        chart.update()
      chart;
  )
line_chart = (label) ->
  chart = nv.models.lineChart()
    .margin({left: 100, right: 20})  #Adjust chart margins to give the x-axis some breathing room.
    .useInteractiveGuideline(true)  #We want nice looking tooltips and a guideline!
    .transitionDuration(350)  #how fast do you want the lines to transition?
    .showLegend(true)       #Show the legend, allowing users to turn on/off line series.
    .showYAxis(true)        #Show the y-axis
    .showXAxis(true)        #Show the x-axis
  chart.xAxis     #Chart x-axis settings
      .axisLabel('Date')
      .tickFormat (d) ->
        d3.time.format('%d/%b/% %H:%M')(new Date(d));
  chart.yAxis     #Chart y-axis settings
      .axisLabel(label)
      .tickFormat(d3.format(',r'));
  chart
window.d3_charts = d3_charts
window.line_chart = line_chart
window.d3line = d3line
horizontal_bar = (data, target) ->
  nv.addGraph ->
    chart = nv.models.multiBarHorizontalChart()
      .x(((d) -> d.label ))
      .y(((d) -> d.value ))
      .margin({top: 30, right: 20, bottom: 50, left: 175})
      .showValues(true)
      .tooltips(true)
      .transitionDuration(350)
      .stacked(true)
      .showControls(false);
    chart.yAxis
        .tickFormat(d3.format(',.2f'));
    chart.multibar.dispatch.on 'elementClick', (e) ->
      if e.point.url != undefined
        $('#ajax-modal').modal
          remote: e.point.url
    d3.select(target)
        .datum(data)
        .call(chart);

    nv.utils.windowResize(chart.update);

    chart;
window.horizontal_bar = horizontal_bar
