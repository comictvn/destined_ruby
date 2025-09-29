class CreateOauthAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_access_tokens do |t|
      t.references :resource_owner_id, null: false
      t.string :token, null: false, index: { unique: true }
      t.string :refresh_token, null: false, index: { unique: true }
      t.integer :expires_in, null: false
      t.datetime :revoked_at
      t.datetime :created_at, null: false
      t.text :scopes, null: false
      t.string :previous_refresh_token
      t.string :resource_owner_type, null: false
      t.integer :refresh_expires_in, null: false
      t.references :application_id, null: false, foreign_key: { to_table: :oauth_applications }
      t.references :user_id, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end