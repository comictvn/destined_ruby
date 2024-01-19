class CreateArticleTags < ActiveRecord::Migration[6.0]
  def change
    create_table :article_tags do |t|
      t.timestamps
      t.references :article, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
