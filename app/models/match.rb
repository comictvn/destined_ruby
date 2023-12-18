class Match < ApplicationRecord
  self.table_name = 'matchs'

  belongs_to :matcher1,
             class_name: 'User',
             foreign_key: 'matcher1_id'
  belongs_to :matcher2,
             class_name: 'User',
             foreign_key: 'matcher2_id'
  has_many :messages,
           foreign_key: 'match_id'
end
