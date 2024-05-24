class CreateTest3s < ActiveRecord::Migration[7.0]
  def change
    create_table :test3s do |t|

      t.timestamps
    end
  end
end
