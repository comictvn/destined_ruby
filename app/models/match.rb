class Match < ApplicationRecord
  # It seems like the table name was changed from 'matchs' to 'matches'.
  # To resolve the conflict, we should use the new table name 'matches'.
  self.table_name = 'matches'

  # The associations with :matcher1 and :matcher2 remain the same in both versions.
  # No conflict here, so we keep them as is.
  belongs_to :matcher1,
             class_name: 'User'
  belongs_to :matcher2,
             class_name: 'User'
end
