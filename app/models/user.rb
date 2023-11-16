class User < ApplicationRecord
  # validations
  validates :name, presence: true
  validates :preferences, presence: true
  validates :match_id, presence: true
  # associations
  belongs_to :match, foreign_key: :match_id
  has_many :matches, foreign_key: :user_id
end
