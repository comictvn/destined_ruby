class CreateDesignFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :design_files do |t|
      t.string :file_name
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end