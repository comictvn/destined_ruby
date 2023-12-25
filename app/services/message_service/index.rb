# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Message
  end

  def execute
    filter_and_paginate_messages
  end

  def filter_and_paginate_messages
    sender_id_equal
    chanel_id_equal
    content_start_with
    order
    paginate

    {
      records: @records,
      total_pages: @records.total_pages,
      current_page: @records.current_page,
      limit: @records.limit_value
    }
  end

  private

  def sender_id_equal
    return if params.dig(:messages, :sender_id).blank?

    @records = @records.where(sender_id: params.dig(:messages, :sender_id))
  end

  def chanel_id_equal
    return if params.dig(:messages, :chanel_id).blank?

    @records = if records.is_a?(Class)
                 @records.where(chanel_id: params.dig(:messages, :chanel_id))
               else
                 records.or(@records.where(chanel_id: params.dig(:messages, :chanel_id)))
               end
  end

  def content_start_with
    return if params.dig(:messages, :content).blank?

    @records = if records.is_a?(Class)
                 @records.where('content LIKE ?', "#{params.dig(:messages, :content)}%")
               else
                 records.or(@records.where('content LIKE ?', "#{params.dig(:messages, :content)}%"))
               end
  end

  def order
    return if records.blank?

    @records = records.order(created_at: :desc)
  end

  def paginate
    page_number = params.dig(:pagination, :page).to_i || 1
    limit_value = params.dig(:pagination, :limit).to_i || 20
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(page_number).per(limit_value)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
