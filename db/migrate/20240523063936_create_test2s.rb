class CreateTest2s < ActiveRecord::Migration[7.0]
  def change
    create_table :test2s do |t|

      t.timestamps
    end
  end
end
