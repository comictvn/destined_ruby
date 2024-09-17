
class CreateDesignFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :design_files do |t|
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :access_level, null: false

      t.timestamps
    end

    add_index :layers, :design_file_id unless index_exists?(:layers, :design_file_id)
    add_index :color_styles, :design_file_id unless index_exists?(:color_styles, :design_file_id)
  end
end
