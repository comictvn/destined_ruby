# PATH: /app/services/message_service/delete.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Delete
  attr_accessor :chanel_id, :id
  def initialize(chanel_id, id)
    raise 'Wrong format' unless chanel_id.is_a?(Integer) && id.is_a?(Integer)
    @chanel = Chanel.find_by(id: chanel_id)
    raise 'This chanel is not found' unless @chanel
    @message = @chanel.messages.find_by(id: id)
    raise 'This message is not found' unless @message
    @chanel_id = chanel_id
    @id = id
  end
  def execute
    @message.destroy
  end
end
# rubocop:enable Style/ClassAndModuleChildren
