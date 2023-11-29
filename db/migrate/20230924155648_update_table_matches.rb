class UpdateTableMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :compatibility_score, :float
    add_column :matches, :user_id, :integer
    add_foreign_key :matches, :users, column: :user_id
  end
end
