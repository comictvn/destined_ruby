class CreateOtpRequestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_requests do |t|
      t.string :otp_code, null: false
      t.datetime :expires_at, null: false
      t.boolean :verified, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
