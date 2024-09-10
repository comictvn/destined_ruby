if @message.present?
  json.message @message
else
  json.total_pages @total_pages
  json.messages @messages do |message|
    json.id message.id
    json.created_at message.created_at
    json.updated_at message.updated_at
    sender = message.sender
    if sender.present?
      json.sender do
        json.id sender.id
        json.name sender.name
        json.created_at sender.created_at
        json.updated_at sender.updated_at
        json.location sender.location
      end
    end
    json.sender_id message.sender_id
    channel = message.channel
    if channel.present?
      json.channel do
        json.id channel.id
        json.created_at channel.created_at
        json.updated_at channel.updated_at
      end
    end
    json.channel_id message.channel_id
    json.content message.content
    json.images message.images
  end
end