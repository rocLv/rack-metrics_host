json.array! @memory do |request|
  time = Time.parse(request[0])
  memory = request[1]
  json.label "#{time.hour}:#{time.min}"
  json.tooltip "<div class='chart-tooltip'>#{memory}MB at #{time.hour}:#{time.min}</div>"
  json.value request[1].round
end