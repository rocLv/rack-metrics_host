json.array! @rpm do |request|
  time = Time.parse(request[0])
  json.label "#{time.hour}:#{time.min}"
  json.tooltip "<div class='chart-tooltip'>#{request[1]}rpm at #{time.hour}:#{time.min}</div>"
  json.value request[1]
end