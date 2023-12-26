# PATH: /app/services/chanel_service/messages_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChanelService::MessagesService
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = Message.where(chanel_id: params[:chanel_id])
  end
  def index
    validate_params
    order
    paginate
    format_response
  rescue StandardError => e
    { error: e.message }
  end
  def validate_params
    raise "This chanel is not found" unless Chanel.exists?(params[:chanel_id])
    raise "Wrong format" unless params[:chanel_id].is_a? Integer
  end
  def order
    return if records.blank?
    @records = records.order('messages.created_at desc')
  end
  def paginate
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def format_response
    {
      status: 200,
      messages: @records,
      total_messages: @records.count,
      total_pages: @records.total_pages
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
