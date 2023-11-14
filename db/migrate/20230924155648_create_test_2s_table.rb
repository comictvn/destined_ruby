class CreateTest2sTable < ActiveRecord::Migration[6.0]
  def change
    create_table :test_2s do |t|
      t.string :name
      t.string :status
      t.timestamps
    end
  end
end
