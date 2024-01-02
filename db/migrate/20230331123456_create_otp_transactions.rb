class CreateOtpTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :otp_transactions do |t|
      t.timestamps
      t.string :transaction_id, null: false
      t.string :status, null: false
      t.references :otp_request, null: false, foreign_key: true
    end
  end
end
