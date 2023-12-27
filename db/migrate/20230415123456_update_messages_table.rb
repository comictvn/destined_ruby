class UpdateMessagesTable < ActiveRecord::Migration[7.0]
  def up
    # Add new column 'conversation_id' to the messages table
    add_column :messages, :conversation_id, :bigint
    # Add foreign key for 'conversation_id' column referencing 'conversations' table
    add_foreign_key :messages, :conversations, column: :conversation_id

    # Remove 'chanel_id' and 'sender_id' columns as they are no longer needed
    remove_column :messages, :chanel_id, :bigint
    remove_column :messages, :sender_id, :bigint

    # Rename 'message_text' to 'content'
    rename_column :messages, :message_text, :content

    # Add index to 'conversation_id' for better query performance
    add_index :messages, :conversation_id
  end

  def down
    # Remove index from 'conversation_id'
    remove_index :messages, :conversation_id

    # Rename 'content' back to 'message_text'
    rename_column :messages, :content, :message_text

    # Add 'chanel_id' and 'sender_id' columns back to the messages table
    add_column :messages, :chanel_id, :bigint
    add_column :messages, :sender_id, :bigint

    # Remove foreign key and 'conversation_id' column
    remove_foreign_key :messages, column: :conversation_id
    remove_column :messages, :conversation_id, :bigint
  end
end
