class CreateMediaTable < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.timestamps
      t.string :file_path
      t.string :media_type
      t.references :article, foreign_key: true
    end
  end
end
