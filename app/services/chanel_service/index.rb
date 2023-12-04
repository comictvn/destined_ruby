# rubocop:disable Style/ClassAndModuleChildren
class ChanelService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = Chanel
  end
  def execute
    index
    order
    paginate
    format_response
  end
  def index
    @records = Chanel.all
  end
  def order
    return if records.blank?
    @records = records.order('chanels.created_at desc')
  end
  def paginate
    @records = Chanel.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def format_response
    {
      total_items: @records.total_count,
      total_pages: @records.total_pages,
      chanels: @records
    }
  end
  def find_by_id(id)
    chanel = Chanel.find_by(id: id)
    raise ActiveRecord::RecordNotFound, "Couldn't find Chanel with 'id'=#{id}" if chanel.nil?
    chanel
  end
end
# rubocop:enable Style/ClassAndModuleChildren
