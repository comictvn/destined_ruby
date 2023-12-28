class AddUserChanelsAndOtpRequestsRelationsToUsers < ActiveRecord::Migration[6.0]
  def change
    # Since the user_chanels and otp_requests tables are assumed to exist,
    # we only need to add the references to the users table.

    # Add a reference to user_chanels.user_id
    add_reference :user_chanels, :user, foreign_key: true unless foreign_key_exists?(:user_chanels, :user)

    # Add a reference to otp_requests.user_id
    add_reference :otp_requests, :user, foreign_key: true unless foreign_key_exists?(:otp_requests, :user)
  end
end
