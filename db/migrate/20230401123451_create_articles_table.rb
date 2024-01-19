class CreateArticlesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :articles, :title, unique: true
  end
end
