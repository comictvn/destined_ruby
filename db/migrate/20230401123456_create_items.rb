class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :discounted_price, precision: 10, scale: 2, null: false
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end