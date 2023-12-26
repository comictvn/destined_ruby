class CreatePasswordResetRequestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :password_reset_requests do |t|
      t.datetime :request_time
      t.string :status
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
