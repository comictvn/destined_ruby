class UpdateMessagesTable < ActiveRecord::Migration[6.0]
  def change
    # Add new column 'message_text' to the 'messages' table
    add_column :messages, :message_text, :text

    # Add new column 'chanel_id' to the 'messages' table
    add_reference :messages, :chanel, foreign_key: true

    # Add new column 'user_id' to the 'messages' table
    add_reference :messages, :user, foreign_key: true

    # Remove 'content' column as it is replaced by 'message_text'
    remove_column :messages, :content, :string
  end
end
