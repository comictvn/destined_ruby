
class CreateStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :styles do |t|
      t.string :name, null: false
      t.references :ui_component, foreign_key: true, index: true

      t.timestamps
    end
  end
end
