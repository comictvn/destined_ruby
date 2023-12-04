# PATH: /app/services/chanel_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChanelService::Index
  attr_accessor :params, :records, :query, :chanel_id
  def initialize(params, _current_user = nil)
    @params = params
    @records = Chanel
    @chanel_id = params[:chanel_id]
  end
  def execute
    validate_chanel_id
    order
    paginate
    get_messages
    format_response
  end
  def validate_chanel_id
    raise 'Invalid chanel_id' unless Chanel.exists?(id: chanel_id)
  end
  def order
    return if records.blank?
    @records = records.order('chanels.created_at desc')
  end
  def paginate
    @records = Chanel.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def get_messages
    @records = Message.where(chanel_id: chanel_id)
  end
  def format_response
    {
      messages: records,
      total_messages: records.count,
      total_pages: (records.count / 20.0).ceil
    }
  end
  def delete_message(chanel_id, id)
    chanel = Chanel.find(chanel_id)
    message = chanel.messages.find(id)
    message.destroy
  rescue ActiveRecord::RecordNotFound => e
    raise e
  end
end
# rubocop:enable Style/ClassAndModuleChildren
