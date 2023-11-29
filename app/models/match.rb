class Match < ApplicationRecord
  self.table_name = 'matchs'
  belongs_to :matcher1,
             class_name: 'User'
  belongs_to :matcher2,
             class_name: 'User'
  has_many :messages, dependent: :destroy
  validates :compatibility_score, presence: true
end
