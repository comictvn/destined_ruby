if @message.present?
  json.message @message
else
  json.chanel do
    json.id @chanel.id
    json.created_at @chanel.created_at
    json.updated_at @chanel.updated_at
    json.messages @chanel.messages do |message|
      json.id message.id
      json.created_at message.created_at
      json.updated_at message.updated_at
      json.sender_id message.sender_id
      json.chanel_id message.chanel_id
    end
    json.user_chanels @chanel.user_chanels do |user_chanel|
      json.id user_chanel.id
      json.created_at user_chanel.created_at
      json.updated_at user_chanel.updated_at
      json.user_id user_chanel.user_id
      json.chanel_id user_chanel.chanel_id
    end
  end
end
