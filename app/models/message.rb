class Message < ApplicationRecord
  self.table_name = 'messages'

  # Define relationships
  belongs_to :match, class_name: 'Match', foreign_key: 'match_id', optional: true
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :chanel, class_name: 'Chanel', foreign_key: 'chanel_id'

  # Active Storage for images
  has_many_attached :images, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { in: 0..65_535 }, if: :content?
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :match_id, presence: true, if: :match_id?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }, if: :images_attached?

  # Add any custom methods below
  # ...

  private

  def images_attached?
    images.attached?
  end

  def match_id?
    match_id.present?
  end

  def content?
    content.present?
  end
end
