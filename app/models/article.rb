class Article < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'articles'

  # Define relationships with other models
  belongs_to :user
  has_many :media, dependent: :destroy
  has_many :article_tags, dependent: :destroy

  # Add validations for model attributes
  validates :title, presence: true, length: { maximum: 200 }, message: ->(object, data) do
    I18n.t('activerecord.errors.models.article.attributes.title.too_long', count: 200)
  end
  validates :content, presence: true, length: { maximum: 10000 }, message: ->(object, data) do
    I18n.t('activerecord.errors.models.article.attributes.content.too_long', count: 10000)
  end
  validates :status, presence: true, inclusion: { in: %w[draft published archived] }
  validates :user_id, presence: true

  # Scope to get articles by user_id
  scope :by_user, ->(user_id) {
    where(user_id: user_id)
  }

  # Class method as an alternative to the scope
  def self.for_user(user_id)
    by_user(user_id)
  end

  # ... rest of the model code ...
end
