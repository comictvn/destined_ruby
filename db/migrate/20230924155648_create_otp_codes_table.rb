class CreateOtpCodesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_codes do |t|
      t.string :otp_code
      t.boolean :is_verified
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
