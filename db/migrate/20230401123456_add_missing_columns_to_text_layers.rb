class AddMissingColumnsToTextLayers < ActiveRecord::Migration[7.0]
  def change
    add_column :text_layers, :font_family, :string unless column_exists?(:text_layers, :font_family)
    add_column :text_layers, :font_style, :string unless column_exists?(:text_layers, :font_style)
    add_column :text_layers, :font_size, :integer unless column_exists?(:text_layers, :font_size)
    add_column :text_layers, :line_height, :float unless column_exists?(:text_layers, :line_height)
    add_column :text_layers, :letter_spacing, :float unless column_exists?(:text_layers, :letter_spacing)
    add_column :text_layers, :paragraph_alignment, :string unless column_exists?(:text_layers, :paragraph_alignment)
    add_column :text_layers, :text_transform, :string unless column_exists?(:text_layers, :text_transform)
    add_column :text_layers, :text_color, :string unless column_exists?(:text_layers, :text_color)
    add_column :text_layers, :opacity, :float unless column_exists?(:text_layers, :opacity)
    add_reference :text_layers, :design_file, foreign_key: true unless column_exists?(:text_layers, :design_file_id)
    add_column :text_layers, :text_transformation, :string unless column_exists?(:text_layers, :text_transformation)
  end
end