
class CreateArticlesTable < ActiveRecord::Migration[7.0]
  def change
    unless column_exists? :articles, :status
      add_column :articles, :status, :string
    end
  end
end
