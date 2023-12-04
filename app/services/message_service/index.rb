# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = Message
  end
  def execute
    validate_input
    fetch_messages_by_chanel_id
    sender_id_equal
    chanel_id_equal
    content_start_with
    order
    paginate
    { messages: @records, total: total_messages }
  end
  def validate_input
    raise 'Content cannot be empty' if params.dig(:messages, :content).blank?
    raise 'User does not exist' unless User.exists?(params.dig(:messages, :user_id))
    validate_chanel_id
  end
  def validate_chanel_id
    raise 'Invalid chanel_id' unless Chanel.exists?(params[:chanel_id] || params.dig(:messages, :chanel_id))
  end
  def fetch_messages_by_chanel_id
    @records = Message.where(chanel_id: params[:chanel_id] || params.dig(:messages, :chanel_id))
  end
  def sender_id_equal
    return if params.dig(:messages, :sender_id).blank?
    @records = Message.where('sender_id = ?', params.dig(:messages, :sender_id))
  end
  def chanel_id_equal
    return if params.dig(:messages, :chanel_id).blank?
    @records = if records.is_a?(Class)
                 Message.where(value.query)
               else
                 records.or(Message.where('chanel_id = ?', params.dig(:messages, :chanel_id)))
               end
  end
  def content_start_with
    return if params.dig(:messages, :content).blank?
    @records = if records.is_a?(Class)
                 Message.where(value.query)
               else
                 records.or(Message.where('content like ?', "%#{params.dig(:messages, :content)}"))
               end
  end
  def order
    return if records.blank?
    @records = records.order('messages.created_at desc')
  end
  def paginate
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def total_messages
    @records.count
  end
end
# rubocop:enable Style/ClassAndModuleChildren
