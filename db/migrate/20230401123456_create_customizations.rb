class CreateCustomizations < ActiveRecord::Migration[7.0]
  def change
    create_table :customizations do |t|
      t.text :customization_details
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end