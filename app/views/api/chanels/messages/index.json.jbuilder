json.status 200
json.messages @messages do |message|
  json.id message.id
  json.content message.content
  json.user_id message.sender_id
  json.chanel_id message.chanel_id
  json.created_at message.created_at
end
