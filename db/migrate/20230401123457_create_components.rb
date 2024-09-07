class CreateComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :components do |t|
      t.string :name, null: false
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end