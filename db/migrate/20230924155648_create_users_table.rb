class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :failed_attempts
      t.datetime :confirmation_sent_at
      t.string :password
      t.string :unlock_token
      t.string :current_sign_in_ip
      t.datetime :reset_password_sent_at
      t.string :last_sign_in_ip
      t.integer :sign_in_count
      t.text :interests
      t.date :dob
      t.string :password_confirmation
      t.text :location
      t.string :encrypted_password
      t.string :firstname
      t.integer :gender
      t.datetime :current_sign_in_at
      t.string :phone_number
      t.string :reset_password_token
      t.string :unconfirmed_email
      t.datetime :confirmed_at
      t.string :lastname
      t.datetime :last_sign_in_at
      t.string :confirmation_token
      t.datetime :locked_at
      t.datetime :remember_created_at
      t.datetime :created_at
      t.datetime :updated_at
      t.string :email
      t.string :name
      t.text :preferences
      t.string :session_token
      t.integer :match_id
      t.timestamps
    end
  end
end
