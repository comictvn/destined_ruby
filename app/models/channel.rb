class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :user_chanels, dependent: :destroy
end