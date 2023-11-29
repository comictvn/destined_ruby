class CreateMessagesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id
      t.integer :chanel_id
      t.integer :match_id
      t.datetime :timestamp
      t.timestamps
    end
    add_foreign_key :messages, :chanels, column: :chanel_id
    add_foreign_key :messages, :matches, column: :match_id
  end
end
