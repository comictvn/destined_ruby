class AddNameAndDescriptionToChanels < ActiveRecord::Migration[6.0]
  def up
    add_column :chanels, :name, :string
    add_column :chanels, :description, :string
  end
  def down
    remove_column :chanels, :name
    remove_column :chanels, :description
  end
end
