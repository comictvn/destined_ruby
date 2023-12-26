class MessageValidator
  def validate_destroy(chanel_id, id)
    if chanel_id.blank? || id.blank?
      return { status: false, message: 'Chanel ID and Message ID are required.' }
    end
    message = Message.find_by(chanel_id: chanel_id, id: id)
    if message.nil?
      return { status: false, message: 'Message not found.' }
    end
    { status: true, message: 'Validation passed.' }
  end
end
