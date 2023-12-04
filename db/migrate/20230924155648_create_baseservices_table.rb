class CreateBaseservicesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :baseservices do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :health_check
      t.timestamps
    end
  end
end
