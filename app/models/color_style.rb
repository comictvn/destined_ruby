class ColorStyle < ApplicationRecord
  belongs_to :team

  validates :name, presence: true
  validates :color_value, presence: true
  validates :team_id, presence: true
end