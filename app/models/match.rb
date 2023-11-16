class Match < ApplicationRecord
  # associations
  belongs_to :user
  has_one :user, foreign_key: :match_id
  # validations
  validates :team1, :team2, :date, :result, :status, presence: true
end
