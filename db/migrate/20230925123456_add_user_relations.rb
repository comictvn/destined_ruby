class AddUserRelations < ActiveRecord::Migration[6.0]
  def change
    # Add references for user_channels
    add_reference :user_channels, :user, foreign_key: true

    # Add references for otp_requests
    add_reference :otp_requests, :user, foreign_key: true
  end
end