class AddNewColumnsToMessages < ActiveRecord::Migration[6.0]
  def change
    # Assuming the task is to add new columns to the messages table
    # The specific column types are not provided in the "# TABLE" section, so I'll use common types
    # Replace `:string` or `:integer` with the correct types if they are known

    # Add new columns
    add_column :messages, :message_text, :text
    # Add any other new columns here following the same pattern
    # Example: add_column :messages, :new_column_name, :new_column_type

    # Since the relationships are mentioned, ensure that the foreign keys are indexed
    # This is already done for match_id in the provided migration file
    # If there are new foreign keys, add indexes for them as well
    # Example: add_index :messages, :new_foreign_key_column
  end
end
