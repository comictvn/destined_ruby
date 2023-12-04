class Message < ApplicationRecord
  belongs_to :user, foreign_key: 'sender_id'
  belongs_to :chanel
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  has_many_attached :images, dependent: :destroy
  # validations
  validates :content, presence: true, length: { in: 0..65_535 }
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :user_id, presence: true
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
  def self.create_message(content, user_id, chanel_id)
    message = self.new(content: content, user_id: user_id, chanel_id: chanel_id)
    if message.save
      return message.id
    else
      return nil
    end
  end
end
