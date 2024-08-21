class DesignFile < ApplicationRecord
  belongs_to :team

  validates :file_name, presence: true
  validates :team_id, presence: true
end