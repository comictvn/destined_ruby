# PATH: /app/services/message_service/delete.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Delete
  attr_accessor :chanel_id, :id
  def initialize(chanel_id, id)
    @chanel_id = chanel_id
    @id = id
  end
  def execute
    message = Message.find_by(chanel_id: chanel_id, id: id)
    return { status: :not_found, message: 'Message not found' } unless message
    if message.destroy
      { status: :success, message: 'Message deleted successfully' }
    else
      { status: :error, message: 'Failed to delete message' }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
