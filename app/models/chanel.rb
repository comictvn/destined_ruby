class Chanel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :user_chanels, dependent: :destroy
  validates :chanel_id, presence: true
end
