class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many_attached :images, dependent: :destroy
  # validations
  validates :content, presence: true, length: { in: 0..65_535 }, if: :content?
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :timestamp, presence: true
  validates :content, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
  # end for validations
end
