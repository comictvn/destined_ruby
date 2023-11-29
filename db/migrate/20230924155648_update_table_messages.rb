class UpdateTableMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :message_content, :string
    add_column :messages, :timestamp, :datetime
    add_column :messages, :user_id, :integer
    add_column :messages, :match_id, :integer
    add_foreign_key :messages, :users, column: :user_id
    add_foreign_key :messages, :matches, column: :match_id
  end
end
