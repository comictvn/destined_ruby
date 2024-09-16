
class CreateUiComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :ui_components do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
