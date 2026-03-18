class CreatePhoneVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :phone_verifications do |t|
      t.string :phone_number, null: false
      t.string :country_code, null: false
      t.string :verification_code, null: false
      t.boolean :verified, default: false, null: false
      t.datetime :sent_at, null: false

      t.timestamps
    end
  end
end