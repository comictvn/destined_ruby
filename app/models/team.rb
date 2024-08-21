class Team < ApplicationRecord
  has_many :design_files
  has_many :color_styles
  has_many :team_members

  validates :name, presence: true
end