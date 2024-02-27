class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def up
    # Add new fields with appropriate data types and constraints
    # Example for adding a new column:
    # add_column :users, :new_column_name, :data_type, options
  end

  def down
    # Remove the fields that were added in the up method
    # Example for removing a column:
    # remove_column :users, :new_column_name
  end
end
