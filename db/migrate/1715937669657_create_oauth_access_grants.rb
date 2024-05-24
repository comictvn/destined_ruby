class CreateOauthAccessGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_access_grants do |t|
      t.timestamps
      t.integer :resource_owner_id
      t.string :token, null: false
      t.integer :expires_in
      t.string :redirect_uri
      t.datetime :revoked_at
      t.string :scopes
      t.string :resource_owner_type
      t.integer :application_id

      t.index :token, unique: true
      t.index :resource_owner_id
      t.index :application_id
    end
  end
end