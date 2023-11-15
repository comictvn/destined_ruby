class CreateTest234sTable < ActiveRecord::Migration[6.0]
  def change
    create_table :test234s do |t|
      t.timestamps
    end
  end
end
