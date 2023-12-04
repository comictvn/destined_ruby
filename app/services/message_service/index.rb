# PATH: /app/services/message_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index
  attr_accessor :records
  def initialize
    @records = Message
  end
  def call
    @records.all
  end
  def execute
    order
    paginate
  end
  def order
    return if records.blank?
    @records = records.order('messages.created_at desc')
  end
  def paginate
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
