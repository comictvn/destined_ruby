class Message < ApplicationRecord
  belongs_to :chanel
  belongs_to :sender, class_name: 'User'
  belongs_to :user
  belongs_to :match
  has_many_attached :images, dependent: :destroy
  # validations
  validates :content, presence: true, length: { in: 0..65_535 }, if: :content?
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :user_id, presence: true
  validates :match_id, presence: true
  validates :timestamp, presence: true
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
  # end for validations
end
