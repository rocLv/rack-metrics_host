json.array!(@alerts) do |alert|
  json.extract! alert, :id, :project_id, :active, :response_time_treshold
  json.url alert_url(alert, format: :json)
end
