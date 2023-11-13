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

        json.created_at sender.created_at

        json.updated_at sender.updated_at

        json.phone_number sender.phone_number

        json.thumbnail sender.thumbnail

        json.firstname sender.firstname

        json.lastname sender.lastname

        json.dob sender.dob

        json.gender sender.gender

        json.interests sender.interests

        json.location sender.location
      end
    end

    json.sender_id message.sender_id

    chanel = message.chanel
    if chanel.present?
      json.chanel do
        json.id chanel.id

        json.created_at chanel.created_at

        json.updated_at chanel.updated_at
      end
    end

    json.chanel_id message.chanel_id

    json.content message.content

    json.images message.images
  end

end
