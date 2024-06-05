# rubocop:disable Style/ClassAndModuleChildren
class MessageService::Index
  def attach_images(message, image_files)
    return unless image_files

    image_files.each do |image|
      next unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif image/svg+xml])
      next unless image.size <= 100.megabytes

      message.images.attach(image)
    end
  end

  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Message
  end

  def execute
    sender_id_equal

    chanel_id_equal

    content_start_with

    order

    paginate
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
    @records = Message.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
