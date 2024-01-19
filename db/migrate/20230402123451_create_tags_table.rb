class CreateTagsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.timestamps
      t.string :name

      t.index :name, unique: true
    end

    # Assuming the article_tags table and ArticleTag model already exist
    # Add a foreign key reference to the tags table from the article_tags table
    add_reference :article_tags, :tag, foreign_key: true
  end
end
