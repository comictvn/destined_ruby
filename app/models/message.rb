class Message < ApplicationRecord
  belongs_to :chanel
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
end
