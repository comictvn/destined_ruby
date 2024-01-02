class AddInterestsDobLocationToUsers < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the users table
    add_column :users, :interests, :text
    add_column :users, :dob, :date
    add_column :users, :location, :string
  end
end
