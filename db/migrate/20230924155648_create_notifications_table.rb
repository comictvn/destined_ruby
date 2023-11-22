class CreateNotificationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
