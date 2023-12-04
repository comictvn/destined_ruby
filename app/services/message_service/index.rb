# PATH: /app/services/message_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = Message
  end
  def self.call(params)
    new(params).execute
  end
  def execute
    validate_input
    fetch_messages_by_chanel_id
    order
    paginate
    { messages: @records, total: total_messages, total_pages: total_pages }
  end
  def validate_input
    raise 'The chanel is not found.' unless Chanel.exists?(params[:chanel_id])
  end
  def fetch_messages_by_chanel_id
    @records = Message.where(chanel_id: params[:chanel_id])
  end
  def order
    return if records.blank?
    @records = records.order('messages.created_at desc')
  end
  def paginate
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(params[:pagination_page] || 1).per(params[:pagination_limit] || 20)
  end
  def total_messages
    @records.count
  end
  def total_pages
    @records.total_pages
  end
end
# rubocop:enable Style/ClassAndModuleChildren
