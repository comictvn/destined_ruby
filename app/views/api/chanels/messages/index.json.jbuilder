json.status 'success'
json.array! @messages do |message|
  json.extract! message, :id, :chanel_id, :content
end
