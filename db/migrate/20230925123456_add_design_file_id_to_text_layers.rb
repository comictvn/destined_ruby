class AddDesignFileIdToTextLayers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists? :text_layers, :design_file_id
      add_reference :text_layers, :design_file, null: false, foreign_key: true
    end
  end
end