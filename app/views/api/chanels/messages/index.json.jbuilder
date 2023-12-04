json.array! @messages do |message|
  json.extract! message, :id, :content, :sender_id, :created_at, :updated_at, :chanel_id
  sender = message.sender
  if sender.present?
    json.sender do
      json.extract! sender, :id, :created_at, :updated_at, :phone_number, :thumbnail, :firstname, :lastname, :dob, :gender, :interests, :location
    end
  end
  chanel = message.chanel
  if chanel.present?
    json.chanel do
      json.extract! chanel, :id, :created_at, :updated_at
    end
  end
end
json.total @messages.count
json.pages @total_pages
