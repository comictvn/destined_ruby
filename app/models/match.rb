class Match < ApplicationRecord
  validates :team1, presence: true
  validates :team2, presence: true
  validates :date, presence: true
  validates :result, presence: true
end
