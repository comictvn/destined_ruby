class CreateTextStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :text_styles do |t|
      t.string :name
      t.string :font_family
      t.string :font_style
      t.integer :font_size
      t.float :line_height
      t.float :letter_spacing
      t.string :paragraph_alignment
      t.string :text_transform
      t.string :text_color
      t.float :opacity

      t.timestamps
    end
  end
end