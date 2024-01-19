class AddResourceOwnerTypeToOauthAccessGrants < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:oauth_access_grants, :resource_owner_type)
      add_column :oauth_access_grants, :resource_owner_type, :string, null: false
      add_index :oauth_access_grants, [:resource_owner_id, :resource_owner_type], name: 'index_oauth_access_grants_on_owner'
    end

    unless column_exists?(:oauth_access_grants, :oauth_application_id)
      add_reference :oauth_access_grants, :oauth_application, null: false, foreign_key: true
    end
  end
end
