class CreateResetPasswordRequestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reset_password_requests do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :otp
      t.string :status
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
