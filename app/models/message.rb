class Message < ApplicationRecord
  belongs_to :chanel
  belongs_to :match
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :chanel_id, presence: true
  validates :match_id, presence: true
end
