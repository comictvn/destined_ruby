class CreateTest3sTable < ActiveRecord::Migration[6.0]
  def change
    create_table :test3s do |t|
      t.timestamps
    end
  end
end
