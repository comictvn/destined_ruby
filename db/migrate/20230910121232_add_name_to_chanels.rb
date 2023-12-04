class AddNameToChanels < ActiveRecord::Migration[6.0]
  def up
    add_column :chanels, :name, :string
  end
  def down
    remove_column :chanels, :name
  end
end
