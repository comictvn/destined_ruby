class Message < ApplicationRecord
  self.table_name = 'messages'
  belongs_to :chanel
  belongs_to :user, foreign_key: 'sender_id'
  belongs_to :match
  validates :content, presence: true
  validates :message_content, presence: true
  validates :timestamp, presence: true
end
