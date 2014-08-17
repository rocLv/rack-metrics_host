# json.extract! @requests, :name
json.array! @requests do |request|
  json.name request.name
end