class CreateForceUpdateAppVersionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :force_update_app_versions do |t|
      t.string :platform
      t.boolean :force_update
      t.string :version
      t.text :reason
      t.timestamps
    end
  end
end
