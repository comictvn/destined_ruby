class AddPhoneVerifiedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone_verified, :boolean, default: false
  end
end
