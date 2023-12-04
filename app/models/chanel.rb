class Chanel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :user_chanels, dependent: :destroy
  # validations
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?
  validates :description, length: { in: 0..255 }, allow_blank: true
end
