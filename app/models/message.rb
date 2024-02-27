class Message < ApplicationRecord
  belongs_to :chanel, class_name: 'Chanel', foreign_key: 'chanel_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates :content, presence: true
  validates :chanel_id, presence: true
  validates :user_id, presence: true

  has_many_attached :images, dependent: :destroy

  validates :content, length: { in: 0..65_535 }, if: :content?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
end
