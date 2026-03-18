
if @error_object.present?
  json.errors @error_object.full_messages
else
  json.message do
    json.id @message.id
    json.created_at @message.created_at
    json.updated_at @message.updated_at

    json.sender_id @message.sender_id
    json.chanel_id @message.chanel_id

    json.content @message.content
    json.images @message.images.map { |image| url_for(image) }
  end
end
