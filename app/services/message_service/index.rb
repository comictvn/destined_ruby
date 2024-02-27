
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index < ApplicationService
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Message
  end
  
  def execute
    validate_chanel_id

    sender_id_equal

    chanel_id_equal

    content_start_with

    order

    paginate
  end

  private

  def validate_chanel_id
    chanel_id = params[:chanel_id]
    raise Exceptions::InvalidParameterError unless chanel_id.is_a?(Integer)
    raise Exceptions::ChannelNotFoundError unless Chanel.exists?(chanel_id)
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
    @records = records.none? ? Message.none : records.page(params[:page] || 1).per(params[:per_page] || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
