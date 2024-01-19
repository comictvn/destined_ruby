class Article < ApplicationRecord
  self.table_name = 'articles'

  # Define attributes for the Article model
  belongs_to :user
  has_many :media, dependent: :destroy
  has_many :article_tags, dependent: :destroy

  # Add validations for model attributes
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft published archived] }
  validates :user_id, presence: true

  # Custom validation message for title and content
  validates_presence_of :title, :content, message: ->(object, data) do
    I18n.t('activerecord.errors.messages.blank')
  end

  # You can also add custom methods, scopes, etc. here
end
