# rubocop:disable Style/ClassAndModuleChildren
class ChanelService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Chanel
  end

  def execute
    filter_by_name if params[:name].present?
    order
    paginate
    metadata = {
      total_records: @records.total_count,
      current_page: @records.current_page,
      limit_per_page: @records.limit_value
    }
    { channels: @records, metadata: metadata }
  rescue StandardError => e
    { error: e.message }
  end

  private

  def filter_by_name
    @records = records.where('name LIKE ?', "%#{params[:name]}%")
  end

  def order
    return if records.blank?

    @records = records.order('chanels.created_at desc')
  end

  def paginate
    @records = Chanel.none if records.blank? || records.is_a?(Class)
    @records = records.page(params[:pagination_page] || 1).per(params[:pagination_limit] || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
