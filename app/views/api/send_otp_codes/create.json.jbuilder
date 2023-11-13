if @message.present?

  json.message @message

else

  json.success @success

  json.message @message

end
