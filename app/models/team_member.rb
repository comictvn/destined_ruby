class TeamMember < ApplicationRecord
  belongs_to :team
  has_one :user

  validates :role, presence: true
  validates :team_id, presence: true
end