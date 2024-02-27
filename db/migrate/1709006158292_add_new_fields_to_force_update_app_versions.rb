class AddNewFieldsToForceUpdateAppVersions < ActiveRecord::Migration[6.0]
  def up
    add_column :force_update_app_versions, :force_update, :boolean, default: false, null: false
    add_column :force_update_app_versions, :platform, :string, null: false
    change_column :force_update_app_versions, :version, :string, limit: 255, null: false
    change_column :force_update_app_versions, :reason, :text, limit: 65_535
  end

  def down
    remove_column :force_update_app_versions, :force_update
    remove_column :force_update_app_versions, :platform
    change_column :force_update_app_versions, :version, :string, limit: 255
    change_column :force_update_app_versions, :reason, :text, limit: 65_535
  end
end
