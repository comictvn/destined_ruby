class Article < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'articles'

  # Define relationships with other models
  belongs_to :user
  has_many :media, dependent: :destroy
  has_many :article_tags, dependent: :destroy

  # Add validations for model attributes
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft published archived] }
  validates :user_id, presence: true

  # You can also add custom methods, scopes, etc. here
end
