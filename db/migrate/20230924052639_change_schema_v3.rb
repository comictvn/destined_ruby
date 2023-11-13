class ChangeSchemaV3 < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.integer :reacter_id, index: true

      t.integer :reacted_id, index: true

      t.integer :react_type, null: false, default: 0

      t.timestamps null: false
    end

    create_table :force_update_app_versions do |t|
      t.integer :platform, null: false, default: ForceUpdateAppVersion.platforms['ios']

      t.boolean :force_update, null: false, default: false

      t.string :version, null: false, default: ''

      t.text :reason

      t.timestamps null: false
    end

    remove_reference :follows, :user, foreign_key: true if foreign_key_exists?(:follows, :users)
    remove_reference :likes, :user, foreign_key: true if foreign_key_exists?(:likes, :users)
    remove_reference :likes, :user, foreign_key: true if foreign_key_exists?(:likes, :users)
    remove_reference :dislikes, :user, foreign_key: true if foreign_key_exists?(:dislikes, :users)
    remove_reference :follows, :user, foreign_key: true if foreign_key_exists?(:follows, :users)
    remove_reference :dislikes, :user, foreign_key: true if foreign_key_exists?(:dislikes, :users)
    drop_table :likes
    drop_table :follows
    drop_table :dislikes

    add_index :reactions, :react_type, unique: true
  end
end
