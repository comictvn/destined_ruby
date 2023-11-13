class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :liked_id, index: true
      t.integer :liker_id, index: true
      t.timestamps null: false
    end
    create_table :matchs do |t|
      t.integer :matcher1_id, index: true
      t.integer :matcher2_id, index: true
      t.timestamps null: false
    end
    create_table :follows do |t|
      t.integer :followed_id, index: true
      t.integer :follower_id, index: true
      t.timestamps null: false
    end
    create_table :chanels do |t|
      t.timestamps null: false
    end
    create_table :users do |t|
      t.integer :failed_attempts, null: false, default: 0
      t.datetime :confirmation_sent_at
      t.string :password
      t.string :unlock_token
      t.string :current_sign_in_ip
      t.datetime :reset_password_sent_at
      t.string :last_sign_in_ip
      t.integer :sign_in_count, null: false, default: 0
      t.text :interests
      t.date :dob, null: false
      t.string :password_confirmation
      t.text :location
      t.string :encrypted_password, null: false, default: ''
      t.string :firstname, null: false, default: ''
      t.string :email, null: false, default: ''
      t.integer :gender, null: false, default: 0
      t.datetime :current_sign_in_at
      t.string :phone_number, null: false, default: ''
      t.string :reset_password_token
      t.string :unconfirmed_email
      t.datetime :confirmed_at
      t.string :lastname, null: false, default: ''
      t.datetime :last_sign_in_at
      t.string :confirmation_token
      t.datetime :locked_at
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    create_table :dislikes do |t|
      t.integer :disliker_id, index: true
      t.integer :disliked_id, index: true
      t.timestamps null: false
    end
    create_table :user_chanels do |t|
      t.timestamps null: false
    end
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id, index: true
      t.timestamps null: false
    end
    create_table :social_media do |t|
      t.string :platform
      t.string :email
      t.text :title
      t.text :content
      t.timestamps null: false
    end
    add_reference :messages, :chanel, foreign_key: true
    add_reference :user_chanels, :chanel, foreign_key: true
    add_reference :user_chanels, :user, foreign_key: true
    add_reference :social_media, :user, foreign_key: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :unconfirmed_email, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
