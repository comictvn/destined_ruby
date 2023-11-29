class Match < ApplicationRecord
  belongs_to :user
  has_many :messages
  validates :compatibility_score, presence: true
end
