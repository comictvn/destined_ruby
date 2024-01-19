class CreateMediaTable < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.references :article, null: false, foreign_key: true, index: true
      t.string :file_path, null: false
      t.string :media_type, null: false

      t.timestamps
    end
  end
end
