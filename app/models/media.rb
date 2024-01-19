
class Media < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'media'

  # Associations
  belongs_to :article, foreign_key: :article_id

  # Validations
  validates :file_path, presence: true
  validates :media_type, presence: true
  validates :article_id, presence: true
end
