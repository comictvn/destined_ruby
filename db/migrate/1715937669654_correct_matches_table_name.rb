class CorrectMatchesTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :matchs, :matches
  end
end