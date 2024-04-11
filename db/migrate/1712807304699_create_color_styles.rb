
class CreateColorStyles < ActiveRecord::Migration[6.0]
  def change
    create_table :color_styles do |t|
      t.string :name
      t.string :color_code
      t.references :design_file, null: false, foreign_key: true
      t.references :layer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
