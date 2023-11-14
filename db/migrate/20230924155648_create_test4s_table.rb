class CreateTest4sTable < ActiveRecord::Migration[6.0]
  def change
    create_table :test4s do |t|
      t.timestamps
    end
  end
end
