class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.integer :failed_attempts, default: 0, null: false
      t.datetime :confirmation_sent_at
      t.string :password
      t.string :unlock_token
      t.string :current_sign_in_ip
      t.datetime :reset_password_sent_at
      t.string :last_sign_in_ip
      t.integer :sign_in_count, default: 0, null: false
      t.text :interests
      t.date :dob
      t.string :password_confirmation
      t.text :location
      t.string :encrypted_password, default: "", null: false
      t.string :firstname, default: "", null: false
      t.integer :gender, default: 0, null: false
      t.datetime :current_sign_in_at
      t.string :phone_number, default: "", null: false
      t.string :reset_password_token
      t.string :unconfirmed_email
      t.datetime :confirmed_at
      t.string :lastname, default: "", null: false
      t.datetime :last_sign_in_at
      t.string :confirmation_token
      t.datetime :locked_at
      t.datetime :remember_created_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :email
      t.string :username
      t.text :preferences
      t.references :match, foreign_key: true
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
  end
end
