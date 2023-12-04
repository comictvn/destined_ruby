# PATH: /app/services/message_service/delete.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Delete
  attr_accessor :chanel_id, :message_id
  def initialize(chanel_id, message_id)
    @chanel_id = chanel_id
    @message_id = message_id
  end
  def delete
    chanel = Chanel.find_by(id: chanel_id)
    return { error: 'Chanel not found' } unless chanel
    message = chanel.messages.find_by(id: message_id)
    return { error: 'Message not found' } unless message
    if message.destroy
      { success: 'Message deleted successfully' }
    else
      { error: 'Failed to delete message' }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
