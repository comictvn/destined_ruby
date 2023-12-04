json.extract! @chanel, :id
if @chanel.errors.any?
  json.error do
    json.message 'An error occurred during the deletion process'
    json.details @chanel.errors.full_messages
  end
else
  json.message 'Chanel was successfully deleted'
end
