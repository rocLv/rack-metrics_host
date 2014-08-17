json.array! @requests do |request|
  # json.id request.id
  # json.label request.started.to_s
  # json.tooltip render(partial: 'tooltip', locals: {request: request}, formats: [:html])
  # json.value [request.duration, request.db_runtime]
  # json.url project_request_path(request.project, request)

  json.label request.started.to_s
  json.response_time request.duration
  json.db_runtime request.db_runtime
  json.tooltip render(partial: 'tooltip', locals: {request: request}, formats: [:html])
end