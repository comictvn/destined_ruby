class CreateTest3sTable < ActiveRecord::Migration[6.0]
  def change
    unless table_exists? :test3s
      create_table :test3s do |t|
        t.timestamps
      end
      puts "Table test3s has been created successfully."
    else
      puts "Table test3s already exists."
    end
  end
end
