class CreateHealthsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :healths do |t|
      t.timestamps
    end
  end
end
