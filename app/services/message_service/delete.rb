# PATH: /app/services/message_service/delete.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Delete
  attr_accessor :chanel_id, :message_id, :user_id
  def initialize(chanel_id, message_id, user_id)
    @chanel_id = chanel_id
    @message_id = message_id
    @user_id = user_id
  end
  def call
    chanel = Chanel.find_by(id: chanel_id)
    return { error: 'The chanel is not found.', status: 400 } unless chanel
    message = chanel.messages.find_by(id: message_id)
    return { error: 'The message is not found.', status: 400 } unless message
    return { error: 'User does not have permission to access the resource.', status: 403 } unless message.user_id == user_id
    if message.destroy
      { status: 200, message: 'The message was successfully deleted.' }
    else
      raise StandardError, 'Failed to delete message.'
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
