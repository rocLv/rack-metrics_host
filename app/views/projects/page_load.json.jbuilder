json.array! @response_time do |request|
  time = Time.parse(request[0])
  json.label "#{time.hour}:#{time.min}"
  json.tooltip "<div class='chart-tooltip'>#{request[1].to_i}ms at #{time.hour}:#{time.min}</div>"
  json.value request[1].to_i
end