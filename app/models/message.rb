class Message < ApplicationRecord
  # Associations
  belongs_to :chanel, class_name: 'Chanel', foreign_key: :chanel_id
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :sender, class_name: 'User', optional: true # optional true to handle the case where sender_id might not be present
  belongs_to :conversation, class_name: 'Conversation', foreign_key: :conversation_id, optional: true # optional true to handle the case where conversation_id might not be present

  has_many_attached :images, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { in: 0..65_535 }, if: :content?
  validates :sender_id, presence: true, allow_nil: true # allow_nil to handle the case where sender_id might not be present
  validates :chanel_id, presence: true
  validates :user_id, presence: true
  validates :conversation_id, presence: true, allow_nil: true # allow_nil to handle the case where conversation_id might not be present
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }, if: :images_attached?

  # Custom methods
  # Add any custom methods for the Message model here

  private

  def images_attached?
    images.attached?
  end
end
