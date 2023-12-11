class AddNewColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    # Assuming the task is to add new columns to the users table
    # The specific column types are not provided in the "# TABLE" section, so I'll use common types
    # Replace `:string` or `:integer` with the correct types if they are known

    # Add new columns
    add_column :users, :age, :integer # Replace :integer with the correct type if needed
    add_column :users, :id, :bigint, null: false, primary_key: true # Assuming id is the primary key
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :password, :string
    add_column :users, :unlock_token, :string
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :interests, :text
    add_column :users, :dob, :date
    add_column :users, :password_confirmation, :string
    add_column :users, :location, :text
    add_column :users, :encrypted_password, :string, default: "", null: false
    add_column :users, :firstname, :string, default: "", null: false
    add_column :users, :gender, :integer, default: 0, null: false # Assuming gender is stored as an integer (enum)
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :phone_number, :string, default: "", null: false
    add_column :users, :reset_password_token, :string
    add_column :users, :unconfirmed_email, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :lastname, :string, default: "", null: false
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :confirmation_token, :string
    add_column :users, :locked_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :created_at, :datetime, null: false
    add_column :users, :updated_at, :datetime, null: false
    add_column :users, :email, :string

    # Add indexes for new columns if necessary
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :phone_number, unique: true
  end
end
