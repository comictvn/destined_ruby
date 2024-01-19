
class ArticleTag < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'article_tags'

  # Define relationships with other models
  # belongs_to :article is already defined
  belongs_to :tag

  # Add validations for model attributes
  validates :article_id, presence: true
  validates :tag_id, presence: true
end
