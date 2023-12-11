class Message < ApplicationRecord
  # Associations
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :chanel
  belongs_to :match, optional: true # Assuming match is optional as it was not present in the existing code

  # Active Storage for images
  has_many_attached :images, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { in: 0..65_535 }, if: :content?
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :match_id, presence: true, if: :match_id?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }, if: :images_attached?

  # Custom methods (if any)
  # ...

  private

  def images_attached?
    images.attached?
  end

  def match_id?
    match_id.present?
  end
end
