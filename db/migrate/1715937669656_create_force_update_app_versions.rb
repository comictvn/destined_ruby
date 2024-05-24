class CreateForceUpdateAppVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :force_update_app_versions do |t|
      t.string :platform, null: false
      t.boolean :force_update, default: false, null: false
      t.string :version, null: false
      t.text :reason

      t.timestamps
    end
  end
end