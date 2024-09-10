class ChannelService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Channel
  end

  def execute
    order

    paginate
  end

  def order
    return if records.blank?

    @records = records.order('channels.created_at desc')
  end

  def paginate
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren