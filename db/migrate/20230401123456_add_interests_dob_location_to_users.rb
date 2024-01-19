class AddInterestsDobLocationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :interests, :text
    add_column :users, :dob, :date
    add_column :users, :location, :string
  end
end
