class CreateApisTable < ActiveRecord::Migration[7.0]
  def change
    create_table :apis do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :endpoint
      t.string :method
      t.timestamps
    end
  end
end
