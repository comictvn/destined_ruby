json.status 200
json.message do
  json.id @message.id
  json.content @message.content
  json.user_id @message.user_id
  json.chanel_id @message.chanel_id
  json.created_at @message.created_at
end
