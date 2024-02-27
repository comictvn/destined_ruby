class Message < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :chanel

  validates :content, presence: true
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :user_id, presence: true

  has_many_attached :images, dependent: :destroy

  validates :content, length: { in: 0..65_535 }, if: :content?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
end
