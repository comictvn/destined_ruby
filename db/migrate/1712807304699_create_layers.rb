
class CreateLayers < ActiveRecord::Migration[6.0]
  def change
    create_table :layers do |t|
      t.string :name
      t.references :design_file, null: false, foreign_key: true

      t.timestamps
    end

    add_index :color_styles, :layer_id unless index_exists?(:color_styles, :layer_id)
  end
end
