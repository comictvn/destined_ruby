class Message < ApplicationRecord
  belongs_to :sender,
             class_name: 'User'
  belongs_to :chanel

  has_many_attached :images, dependent: :destroy
  validates :content, presence: true
  validates :chanel, presence: true

  validates :content, length: { in: 0..65_535 }, if: :content?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
end
