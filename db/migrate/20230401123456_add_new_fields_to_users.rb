class AddNewFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    # Add new fields to the users table
    add_reference :users, :blog, foreign_key: true
    add_reference :users, :gift_card, foreign_key: true
    add_reference :users, :user_chanel, foreign_key: true
    add_reference :users, :user_profile, foreign_key: true
  end
end