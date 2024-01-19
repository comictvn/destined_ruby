class UpdateOauthApplications < ActiveRecord::Migration[6.1]
  def change
    # Add new columns to oauth_applications table
    add_column :oauth_applications, :owner_id, :bigint
    add_column :oauth_applications, :owner_type, :string

    # Add polymorphic index
    add_index :oauth_applications, [:owner_id, :owner_type]

    # Add foreign key for owner_id to users table
    add_foreign_key :oauth_applications, :users, column: :owner_id

    # Add foreign key for oauth_access_grants.oauth_application_id
    add_foreign_key :oauth_access_grants, :oauth_applications, column: :oauth_application_id

    # Add foreign key for oauth_access_tokens.oauth_application_id
    add_foreign_key :oauth_access_tokens, :oauth_applications, column: :oauth_application_id
  end
end
