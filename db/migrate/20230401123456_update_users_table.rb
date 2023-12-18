class UpdateUsersTable < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the users table
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :password_hash, :string, null: false, default: ''

    # Add index to the new username column to ensure uniqueness
    add_index :users, :username, unique: true

    # Create relationships with user_chanels and tasks tables
    # These are assumed to be already handled by the existing code
    # and thus are not included in this migration file.
  end
end
