class CreateTextStyles < ActiveRecord::Migration[6.0]
  def change
    create_table :text_styles do |t|
      t.string :name, null: false
      t.string :font_family, null: false
      t.string :font_style, null: false
      t.integer :font_size, null: false
      t.float :line_height, null: false
      t.float :letter_spacing, null: false
      t.string :paragraph_alignment, null: false
      t.string :text_transform, null: false
      t.string :text_color, null: false
      t.float :opacity, null: false
      t.string :text_transformation, null: false
      t.references :text_layer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
