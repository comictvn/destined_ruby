class CreateTest5sTable < ActiveRecord::Migration[6.0]
  def change
    create_table :test5s do |t|
      t.timestamps
    end
  end
end
