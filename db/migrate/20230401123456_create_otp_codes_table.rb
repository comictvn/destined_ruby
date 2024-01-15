class CreateOtpCodesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :otp_codes do |t|
      t.string :code
      t.datetime :expiration_time
      t.boolean :verified
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
