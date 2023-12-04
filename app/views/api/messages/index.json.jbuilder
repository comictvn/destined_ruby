json.messages @messages do |message|
  json.extract! message, :id, :content, :created_at, :updated_at
end
json.message 'The message has been successfully deleted.'
json.status 200
