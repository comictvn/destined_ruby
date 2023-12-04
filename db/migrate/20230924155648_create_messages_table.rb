class CreateMessagesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id
      t.integer :chanel_id
      t.text :message
      t.timestamps
    end
    add_foreign_key :messages, :chanels, column: :chanel_id
  end
end
