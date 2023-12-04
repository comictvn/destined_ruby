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
    get_messages
    format_response
  end
  def validate_chanel_id
    raise 'Invalid chanel_id' unless Chanel.exists?(id: chanel_id)
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
end
# rubocop:enable Style/ClassAndModuleChildren
