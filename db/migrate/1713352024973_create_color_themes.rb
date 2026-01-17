
class CreateColorThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :color_themes do |t|
      t.string :name, null: false
      t.string :color_code, null: false
      t.references :style, foreign_key: true, index: true

      t.timestamps
    end
  end
end
