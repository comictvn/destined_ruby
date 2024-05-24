class Chanel < ApplicationRecord
  has_many :messages, foreign_key: 'chanel_id', dependent: :destroy
  has_many :user_chanels, foreign_key: 'chanel_id', dependent: :destroy
end
